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
    @reception.hora  = Time.current
  end

  def create
    @reception = Reception.new(reception_params)

    if @reception.save
      redirect_to @reception, notice: 'Recepción creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Acción para el informe con filtros
  def informe
    Rails.logger.debug "Accediendo a la acción informe"
    Rails.logger.debug "Parametros recibidos: #{params.inspect}"
  
    @receptions = Reception.activos
  
    if params[:fecha_inicio].present? && params[:fecha_fin].present? && params[:supplier_id].present?
      Rails.logger.debug "Aplicando filtros de recepción"
      @receptions = @receptions.where(fecha: params[:fecha_inicio]..params[:fecha_fin])
      @receptions = @receptions.where(supplier_id: params[:supplier_id])
      @receptions = @receptions.order(fecha: :desc)
  
      respond_to do |format|
        format.html
        format.xlsx do
          if params[:fecha_inicio].present? && params[:fecha_fin].present? && params[:supplier_id].present?
            response.headers["Content-Disposition"] = "attachment; filename=recepciones_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
          else
            redirect_to informe_receptions_path, alert: 'Debe proporcionar fecha de inicio, fecha de fin y proveedor para exportar a Excel.'
          end
        end
      end
    else
      Rails.logger.debug "Faltan parámetros, mostrando formulario sin filtrar"
      flash.now[:alert] = 'Por favor, complete todos los filtros para generar el informe.' if request.get?
      respond_to do |format|
        format.html
        format.xlsx { redirect_to informe_receptions_path, alert: 'Debe proporcionar fecha de inicio, fecha de fin y proveedor para exportar a Excel.' }
      end
    end
  end

  # app/controllers/receptions_controller.rb
  def export_confirm
    Rails.logger.debug "Parametros recibidos: #{params.inspect}"
  
    @fecha_inicio = params[:fecha_inicio]
    @fecha_fin = params[:fecha_fin]
    @supplier_id = params[:supplier_id]
  
    # Validar la presencia de los parámetros
    unless @fecha_inicio.present? && @fecha_fin.present? && @supplier_id.present?
      flash[:alert] = 'Debe proporcionar fecha de inicio, fecha de fin y proveedor para exportar.'
      redirect_to informe_receptions_path
      return
    end
  
    # Obtener las recepciones filtradas SIN includes(:reception_items)
    @receptions = Reception.activos.where(fecha: @fecha_inicio..@fecha_fin, supplier_id: @supplier_id)
                                 .order(fecha: :asc) # Ordenar por fecha ascendente
  
    # Agrupar las recepciones por fecha
    @variedades_por_dia = @receptions.group_by(&:fecha).transform_values do |recepciones|
      recepciones.flat_map do |reception|
        reception.reception_items.map do |item|
          { variety: item["variety"], price_per_kilogram: item["price_per_kilogram"].to_f }
        end
      end.uniq { |variedad| variedad[:variety] } # Eliminar duplicados por variedad
    end
  
    # Manejar el caso donde no hay variedades
    if @variedades_por_dia.values.flatten.empty?
      flash[:alert] = 'No se encontraron variedades para exportar con los filtros proporcionados.'
      redirect_to informe_receptions_path
    end
  end

  def export
    Rails.logger.debug "Acción 'export' iniciada."
    @receptions = Reception.activos
  
    if params[:fecha_inicio].present? && params[:fecha_fin].present? && params[:supplier_id].present?
      @receptions = @receptions.where(
        fecha: params[:fecha_inicio]..params[:fecha_fin],
        supplier_id: params[:supplier_id]
      ).order(fecha: :desc)
  
      # Permitir y convertir 'precios' a hash puro
      modified_prices = params.require(:precios).permit!.to_h
      Rails.logger.debug "Precios modificados recibidos: #{modified_prices.inspect}"
  
      # Validar precios positivos
      invalid_prices = modified_prices.select { |_, price| price.to_f < 0 }
      if invalid_prices.any?
        Rails.logger.debug "Precios inválidos detectados: #{invalid_prices.inspect}"
        flash[:alert] = 'Todos los precios deben ser números positivos.'
        redirect_to export_confirm_receptions_path(fecha_inicio: params[:fecha_inicio], fecha_fin: params[:fecha_fin], supplier_id: params[:supplier_id])
        return
      end
  
      @variedades_por_dia = @receptions.group_by(&:fecha).transform_values do |recepciones|
        recepciones.flat_map do |reception|
          reception.reception_items.map do |item|
            variedad = item["variety"]
            updated_price = modified_prices[variedad] || item["price_per_kilogram"]
            { variety: variedad, price_per_kilogram: updated_price.to_f }
          end
        end.uniq { |variedad| variedad[:variety] }
      end
  
      Rails.logger.debug "Variedades por día después de actualizar precios: #{@variedades_por_dia.inspect}"
  
      # Agregar un chequeo para evitar el error
      if @variedades_por_dia.values.flatten.empty?
        flash[:alert] = 'No se encontraron variedades para exportar con los filtros proporcionados.'
        redirect_to informe_receptions_path
        return
      end
  
      respond_to do |format|
        format.xlsx do
          Rails.logger.debug "Se está intentando renderizar el Excel."
          render xlsx: 'informe', disposition: 'attachment'
        end
      end
  
    else
      Rails.logger.debug "Parámetros faltantes: fecha_inicio=#{params[:fecha_inicio]}, fecha_fin=#{params[:fecha_fin]}, supplier_id=#{params[:supplier_id]}"
      flash[:alert] = 'Debe proporcionar fecha de inicio, fecha de fin y proveedor para exportar a Excel.'
      redirect_to informe_receptions_path
    end
  rescue => e
    Rails.logger.error "Error en la acción 'export': #{e.message}"
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