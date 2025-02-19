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
    @receptions = Reception.activos.where(fecha: @fecha_inicio..@fecha_fin, supplier_id: @supplier_id).order(fecha: :asc)
  
    # Agrupar variedades por fecha con precios únicos
    @variedades_por_dia = @receptions.each_with_object({}) do |reception, hash|
      fecha = reception.fecha.to_date
      hash[fecha] ||= []
      
      reception.reception_items.each do |item|
        variedad = item["variety"].strip
        precio = item["price_per_kilogram"].to_f
  
        if precio == 0.0
          Rails.logger.warn "⚠ Precio no asignado para #{variedad} en fecha #{fecha}"
        end
  
        hash[fecha] << { variety: variedad, price_per_kilogram: precio }
      end
  
      hash[fecha].uniq! { |v| v[:variety] }  # Eliminar duplicados por variedad
    end
  
    # Si no hay variedades, redirigir con advertencia
    if @variedades_por_dia.empty?
      Rails.logger.warn "⚠ No se encontraron variedades con precios para exportar."
      redirect_to informe_receptions_path, alert: 'No se encontraron variedades con precios para exportar.'
    end
  end
  
  def export
    Rails.logger.debug "📌 Acción 'export' iniciada."
    
    if params[:fecha_inicio].present? && params[:fecha_fin].present? && params[:supplier_id].present?
      @receptions = Reception.activos.where(
        fecha: params[:fecha_inicio]..params[:fecha_fin],
        supplier_id: params[:supplier_id]
      ).order(fecha: :desc)
  
      # Procesar los precios con fecha y variedad
      modified_prices = params.require(:precios).permit!.to_h.transform_keys do |key|
        variedad, fecha = key.rpartition('_').values_at(0, 2)  # Separar variedad y fecha
        [variedad.strip, Date.parse(fecha)]
      end
  
      Rails.logger.debug "📌 Precios modificados recibidos: #{modified_prices.inspect}"
  
      # Validar precios positivos
      invalid_prices = modified_prices.select { |_, price| price.to_f < 0 }
      if invalid_prices.any?
        Rails.logger.warn "⚠ Precios inválidos detectados: #{invalid_prices.inspect}"
        flash[:alert] = 'Todos los precios deben ser números positivos.'
        redirect_to export_confirm_receptions_path(fecha_inicio: params[:fecha_inicio], fecha_fin: params[:fecha_fin], supplier_id: params[:supplier_id])
        return
      end
  
      # Asignar precios a variedades por fecha
      @variedades_por_dia = @receptions.group_by(&:fecha).transform_values do |recepciones|
        recepciones.flat_map do |reception|
          reception.reception_items.map do |item|
            variedad = item["variety"].strip
            fecha = reception.fecha.to_date
            updated_price = modified_prices[[variedad, fecha]] || item["price_per_kilogram"].to_f
            { variety: variedad, price_per_kilogram: updated_price }
          end
        end.uniq { |variedad| variedad[:variety] }
      end
  
      Rails.logger.debug "📌 Variedades con precios actualizados: #{@variedades_por_dia.inspect}"
    
      if @variedades_por_dia.values.flatten.empty?
        flash[:alert] = 'No se encontraron variedades para exportar con los filtros proporcionados.'
        redirect_to informe_receptions_path
        return
      end
  
      respond_to do |format|
        format.xlsx do
          Rails.logger.debug "📌 Generando archivo Excel..."
          render xlsx: 'informe', disposition: 'attachment'
        end
      end
  
    else
      Rails.logger.warn "⚠ Parámetros faltantes para exportar."
      flash[:alert] = 'Debe proporcionar fecha de inicio, fecha de fin y proveedor para exportar a Excel.'
      redirect_to informe_receptions_path
    end
  rescue => e
    Rails.logger.error "❌ Error en la acción 'export': #{e.message}"
    flash[:alert] = 'Ocurrió un error al generar el informe Excel. Por favor, intenta nuevamente.'
    redirect_to informe_receptions_path
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
      item["pallets"] = "0" if item["pallets"].blank?
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
      reception_items: [:sector, :variety, :color, :firmeza, :calidad, :pallets, :cajas, :kilos]
    )
  end
end