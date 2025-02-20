class ReceptionsController < ApplicationController
  # Se asegura que estas variables se carguen en nuevas recepciones o cuando hay errores en create
  before_action :load_collections, only: [:new, :create, :informe, :export_confirm]

  def index
    @receptions = Reception.activos.order(created_at: :desc)
  end

  def show
    @reception = Reception.find(params[:id])
  end

  def new
    @reception = Reception.new
    @reception.fecha = Date.today
    @reception.hora  = Time.zone.now
  end

  def create
    @reception = Reception.new(reception_params)
  
    if @reception.save
      # Guardar la imagen en la tabla `images`
      if params[:reception][:image].present?
        uploaded_file = params[:reception][:image]
        image_data = uploaded_file.read
        
        @image = Image.new(
          reception: @reception,
          image: image_data,
          filename: uploaded_file.original_filename,
          content_type: uploaded_file.content_type
        )
  
        unless @image.save
          flash[:alert] = "Error al guardar la imagen: #{@image.errors.full_messages.join(", ")}"
        end
      end
  
      redirect_to @reception, notice: 'Recepción creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  

  # Acción para el informe con filtros
  def informe
    Rails.logger.debug "Parametros recibidos: #{params.inspect}"
  
    if params[:fecha_inicio].blank? || params[:fecha_fin].blank? || params[:supplier_id].blank?
      flash.now[:alert] = 'Debe seleccionar un rango de fechas y un proveedor.'
      @receptions = []
      return render :informe
    end
  
    @receptions = Reception.activos
                           .where(fecha: params[:fecha_inicio]..params[:fecha_fin])
                           .where(supplier_id: params[:supplier_id])
                           .order(fecha: :desc)
  
    if @receptions.empty?
      flash.now[:alert] = 'No se encontraron recepciones con los filtros seleccionados.'
    end
  end
  
  

  # app/controllers/receptions_controller.rb
  def export_confirm
    Rails.logger.debug "📌 Parámetros recibidos: #{params.inspect}"
  
    @fecha_inicio = params[:fecha_inicio]
    @fecha_fin = params[:fecha_fin]
    @supplier_id = params[:supplier_id]
  
    unless @fecha_inicio.present? && @fecha_fin.present? && @supplier_id.present?
      flash[:alert] = 'Debe proporcionar fecha de inicio, fecha de fin y proveedor para exportar.'
      redirect_to informe_receptions_path
      return
    end
  
    # Obtener las recepciones filtradas
    @receptions = Reception.activos
                           .where(fecha: @fecha_inicio..@fecha_fin, supplier_id: @supplier_id)
                           .order(fecha: :asc)
  
    # Cargar todas las variedades disponibles y mapearlas correctamente
    variedades_data = Variety.pluck(:nombre, :p_supermercado, :p_feria, :p_descarte, :v_supermercado, :v_feria, :v_descarte).each_with_object({}) do |(nombre, p_supermercado, p_feria, p_descarte, v_supermercado, v_feria, v_descarte), hash|
      hash[nombre] = { p_supermercado: p_supermercado, p_feria: p_feria, p_descarte: p_descarte, v_supermercado: v_supermercado, v_feria: v_feria, v_descarte: v_descarte }
    end
  
    # 🔹 Agrupar recepciones por fecha y luego variedades únicas dentro de cada fecha
    @variedades_por_dia = @receptions.group_by(&:fecha).transform_values do |receptions|
      receptions.flat_map(&:reception_items).group_by do |item|
        "#{item['variety']}__#{item['color']}__#{item['calidad']}__#{item['firmeza']}"
      end.map do |key, items|
        variety_name, color, calidad, firmeza = key.split("__")
    
        # Buscar los porcentajes en el hash `variedades_data`
        variedad_data = variedades_data[variety_name] || { p_supermercado: 0.0, p_feria: 0.0, p_descarte: 100.0, v_supermercado: 0.0, v_feria: 0.0, v_descarte: 0.0 }
    
        Rails.logger.info "✅ Procesando variedad: #{key}"
        Rails.logger.info "🔹 Porcentajes obtenidos desde Variety: #{variedad_data.inspect}"
    
        {
          key: key,
          variety: variety_name,
          color: color,
          calidad: calidad,
          firmeza: firmeza,
          p_supermercado: variedad_data[:p_supermercado].to_f,
          p_feria: variedad_data[:p_feria].to_f,
          p_descarte: 100 - (variedad_data[:p_supermercado].to_f + variedad_data[:p_feria].to_f), # 🔹 Ajustado dinámicamente
          v_supermercado: variedad_data[:v_supermercado].to_f,
          v_feria: variedad_data[:v_feria].to_f,
          v_descarte: variedad_data[:v_descarte].to_f
        }
      end.uniq { |v| v[:key] } # 🔹 Asegurar que cada combinación aparezca solo una vez por fecha
    end
    
    # 🔹 Agrupar los kilos por recepción y variedad
    @kilos_por_recepcion = @receptions.index_by(&:id).transform_values do |reception|
      reception.reception_items.group_by do |item|
        "#{item['variety']}__#{item['color']}__#{item['calidad']}__#{item['firmeza']}"
      end.transform_values do |items|
        kilos_totales = items.sum { |item| item["kilos"].to_f }
        Rails.logger.info "📦 Recepción #{reception.id} - Variedad #{items.first['variety']}: #{kilos_totales} kg"
    
        kilos_totales
      end
    end

    @cajas_por_recepcion = @receptions.index_by(&:id).transform_values do |reception|
      reception.reception_items.group_by do |item|
        "#{item['variety']}__#{item['color']}__#{item['calidad']}__#{item['firmeza']}"
      end.transform_values do |items|
        cajas_totales = items.sum { |item| item["cajas"].to_f } # 🔹 Sumar las cajas
        Rails.logger.info "📦 Recepción #{reception.id} - Variedad #{items.first['variety']}: #{cajas_totales} cajas"
    
        cajas_totales
      end
    end
    
    
    Rails.logger.info "📌 Kilos por recepción generados: #{@kilos_por_recepcion.inspect}"
    Rails.logger.info "📌 Cajas por recepción generados: #{@cajas_por_recepcion.inspect}"
  
    # Si no hay variedades, redirigir con advertencia
    if @variedades_por_dia.empty?
      Rails.logger.warn "⚠ No se encontraron variedades con precios para exportar."
      redirect_to informe_receptions_path, alert: 'No se encontraron variedades con precios para exportar.'
    end
  end
  
  
  def export
    Rails.logger.debug "📌 Acción 'export' iniciada."
  
    if params[:fecha_inicio].present? && params[:fecha_fin].present? && params[:supplier_id].present?
      # 🔹 Tomar los valores enviados desde `export_confirm`
      modified_percentages = params[:porcentajes].permit!.to_h
      modified_prices = params[:precios].permit!.to_h
      
  
      Rails.logger.debug "📌 Precios modificados recibidos: #{modified_prices.inspect}"
      Rails.logger.debug "📌 Porcentajes modificados recibidos: #{modified_percentages.inspect}"
  
      # 🔹 Obtener las recepciones del rango de fechas y proveedor
      @receptions = Reception.where(activo: true, fecha: params[:fecha_inicio]..params[:fecha_fin], supplier_id: params[:supplier_id]).order(fecha: :asc)
  
      unless @receptions.exists?
        Rails.logger.error "❌ No se encontraron recepciones para los parámetros dados."
        flash[:alert] = 'No se encontraron datos para exportar con los filtros proporcionados.'
        redirect_to informe_receptions_path and return
      end
  
      Rails.logger.info "📦 Total de recepciones encontradas: #{@receptions.count}"
  
      # 🔹 Agrupar las variedades
      @variedades_por_dia = modified_percentages.keys.group_by { |key| key.split("_").last }.transform_values do |keys|
        keys.map do |key|
          variety_data = key.rpartition("_")  # Separar el nombre de la fecha
          fecha = variety_data.last           # Última parte es la fecha
          variety_info = variety_data.first.split("_")  # Separar la variedad y características
      
          # Extraer desde el final los valores fijos: firmeza, calidad
          firmeza = variety_info.pop
          calidad = variety_info.pop
      
          # Extraer el color (puede contener espacios si el nombre de la variedad es más de una palabra)
          color = variety_info.pop
      
          # Lo que queda en variety_info es el nombre de la variedad
          variety_name = variety_info.join("_")
      
          # 🔹 Tomar precio directamente de `export_confirm`
          
          porcentajes = modified_percentages[key] || {}
          precios = modified_prices[key] || {}
      
          p_supermercado = porcentajes["p_supermercado"].to_f
          p_feria = porcentajes["p_feria"].to_f
          p_descarte = porcentajes["p_descarte"].to_f

          v_supermercado = precios["v_supermercado"].to_f
          v_feria = precios["v_feria"].to_f
          v_descarte = precios["v_descarte"].to_f
      
          Rails.logger.info "✅ Procesando variedad export: #{key}"
          Rails.logger.info "🔹 Nombre: #{variety_name}, Color: #{color}, Calidad: #{calidad}, Firmeza: #{firmeza}"
          Rails.logger.info "🔹 Porcentajes en export: #{porcentajes}"
          Rails.logger.info "🔹 Precios en export: #{precios}"
      
          {
            key: key,
            variety: variety_name,
            color: color,
            calidad: calidad,
            firmeza: firmeza,
            fecha: fecha,
            p_supermercado: p_supermercado,
            p_feria: p_feria,
            p_descarte: p_descarte,
            v_supermercado: v_supermercado,
            v_feria: v_feria,
            v_descarte: v_descarte
          }
        end
      end
      
  
      # 🔹 Agrupar los kilos por recepción y variedad
      @kilos_por_recepcion = @receptions.each_with_object({}) do |reception, hash|
        hash[reception.id] = reception.reception_items.group_by do |item|
          "#{item['variety']}_#{item['color']}_#{item['calidad']}_#{item['firmeza']}"
        end.transform_values { |items| items.sum { |item| item["kilos"].to_f } }
      end

      @cajas_por_recepcion = @receptions.each_with_object({}) do |reception, hash|
        hash[reception.id] = reception.reception_items.group_by do |item|
          "#{item['variety']}_#{item['color']}_#{item['calidad']}_#{item['firmeza']}"
        end.transform_values { |items| items.sum { |item| item["cajas"].to_f } }
      end
      
  
      Rails.logger.debug "📦 Kilos por recepción generados: #{@kilos_por_recepcion.inspect}"
      Rails.logger.debug "📦 Cajas por recepción generados: #{@cajas_por_recepcion}"

      if @variedades_por_dia.values.flatten.empty?
        flash[:alert] = 'No se encontraron variedades para exportar con los filtros proporcionados.'
        redirect_to informe_receptions_path and return
      end
  
      Rails.logger.debug "📊 Datos en @variedades_por_dia: #{@variedades_por_dia.inspect}"
  
      # 🔹 Verificar coincidencia de claves
      Rails.logger.debug "📌 Claves en @variedades_por_dia: #{@variedades_por_dia.keys}"
      Rails.logger.debug "📌 Claves en @kilos_por_recepcion: #{@kilos_por_recepcion.keys}"
  
      respond_to do |format|
        format.xlsx do
          Rails.logger.debug "📄 Se está intentando renderizar el Excel."
          render xlsx: 'informe', disposition: 'attachment'
        end
      end
    else
      flash[:alert] = 'Debe proporcionar fecha de inicio, fecha de fin y proveedor para exportar a Excel.'
      redirect_to informe_receptions_path
    end
  rescue => e
    Rails.logger.error "❌ Error en la acción 'export': #{e.message}"
    flash[:alert] = 'Ocurrió un error al generar el informe Excel. Por favor, intenta nuevamente.'
    redirect_to informe_receptions_path
  end
  
  def destroy
    @reception = Reception.find(params[:id])
    
    if @reception.image_record.present?
      @reception.image_record.destroy  # Esto elimina la imagen asociada
    end
    
    @reception.destroy
    flash[:notice] = "Recepción eliminada exitosamente."
    redirect_to receptions_path
  end
  
  
  
  
  
  
  

  private

  def load_collections
    # Carga de sectores para proveedor Agricola Teruel
    @sectors = Sector.includes(varieties: :colors).all
    @varieties_by_sector = @sectors.each_with_object({}) do |sector, hash|
      hash[sector.id] = sector.varieties.distinct.map do |variety|
        colors = Color.joins(:sector_variety_colors)
                      .where(sector_variety_colors: { sector_id: sector.id, variety_id: variety.id })
                      .distinct
                      .pluck(:nombre)
        { id: variety.id, nombre: variety.nombre, colors: colors }
      end
    end

    # Para proveedores distintos a Agricola Teruel, se listan todas las variedades globalmente
    @all_varieties = Variety.includes(:colors).distinct.map do |variety|
      { id: variety.id, nombre: variety.nombre, colors: variety.colors.pluck(:nombre).uniq }
    end

    # Cargar la lista de proveedores
    @suppliers = Supplier.all
    Rails.logger.debug "@suppliers cargados: #{@suppliers.inspect}"
  end

  def reception_params
    # Procesamos el arreglo de reception_items para asegurarnos
    # de que contenga siempre las claves :pallets, :cajas y :kilos.
    raw_params = params.require(:reception).to_unsafe_h
    raw_params["reception_items"] = Array.wrap(raw_params["reception_items"]).map do |item|
      item = item.to_h.stringify_keys
      item["cajas"]   = "0" if item["cajas"].blank?
      item["kilos"]   = "0" if item["kilos"].blank?
      item
    end

    ActionController::Parameters.new(raw_params).permit(
      :fecha,
      :hora,
      :user_id,
      :nro_guia_despacho,
      :guia_despacho,
      :supplier_id,
      :palets,
      reception_items: [:sector, :variety, :color, :firmeza, :calidad, :cajas, :kilos]
    )
  end
end