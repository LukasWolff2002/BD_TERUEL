class ReceptionsController < ApplicationController
  def index
    @receptions = Reception.activos.order(created_at: :desc)
  end

  def show
    @reception = Reception.find(params[:id])
  end

  def new
    @reception = Reception.new
    @reception.fecha = Date.today
    @reception.hora = Time.current
  
    # Precargar sectores y variedades
    @sectors = Sector.includes(:varieties).all
    @varieties_by_sector = @sectors.each_with_object({}) do |sector, hash|
      hash[sector.id] = sector.varieties.select(:id, :nombre, :color)
    end
  end
  

  def create
    @reception = Reception.new(reception_params)
    
    # Para debugging
    Rails.logger.debug "Parámetros recibidos: #{reception_params.inspect}"
    Rails.logger.debug "Sector ID: #{@reception.sector_id}"
    Rails.logger.debug "Variety ID: #{@reception.variety_id}"

    if @reception.save
      redirect_to @reception, notice: 'Recepción creada exitosamente.'
    else
      Rails.logger.debug "Errores: #{@reception.xaerrors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  # Acción para el informe con filtros
  def informe
    @receptions = Reception.all

    # Filtrar por rango de fechas
    if params[:fecha_inicio].present? && params[:fecha_fin].present?
      @receptions = @receptions.where(fecha: params[:fecha_inicio]..params[:fecha_fin])
    elsif params[:fecha_inicio].present?
      @receptions = @receptions.where("fecha >= ?", params[:fecha_inicio])
    elsif params[:fecha_fin].present?
      @receptions = @receptions.where("fecha <= ?", params[:fecha_fin])
    end

    # Filtrar por sector (usando JOIN con la tabla sectors)
    if params[:sector].present?
      @receptions = @receptions.joins(:sector).where("sectors.nombre ILIKE ?", "%#{params[:sector]}%")
    end

    # Filtrar por nombre (búsqueda parcial sobre el campo 'nombre' de Reception)
    if params[:nombre].present?
      @receptions = @receptions.where("nombre ILIKE ?", "%#{params[:nombre]}%")
    end

    @receptions = @receptions.order(fecha: :desc)

    respond_to do |format|
      format.html
      format.xlsx do
        response.headers["Content-Disposition"] = "attachment; filename=recepciones_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
      end
    end
  end

  private

  def reception_params
    params.require(:reception).permit(
      :fecha,
      :hora,
      :sector_id,
      :variety_id,  # Asegúrate de que sea variety_id,
      :user_id,
      :color,
      :nro_guia_despacho,
      :firmeza,
      :calidad,
      :pallets,
      :cajas,
      :kilos_cajas,
      :guia_despacho
    )
  end
end
