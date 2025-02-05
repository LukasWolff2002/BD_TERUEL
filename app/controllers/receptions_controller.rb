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
