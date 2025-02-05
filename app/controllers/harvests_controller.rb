class HarvestsController < ApplicationController
  before_action :require_login
  
  def index
    @harvests = Harvest.order(fecha: :desc, hora: :desc)
  end

  def new
    @harvest = Harvest.new
    @harvest.fecha = Date.today
    @harvest.hora = Time.current
    
    # Para debugging
    Rails.logger.debug "Nueva cosecha inicializada con fecha: #{@harvest.fecha} y hora: #{@harvest.hora}"
  end

  def create
    @harvest = Harvest.new(harvest_params)
    @harvest.kilos_tomates = @harvest.cajas * @harvest.kilos_por_caja
    
    # Para debugging
    Rails.logger.debug "Parámetros recibidos: #{harvest_params.inspect}"

    if @harvest.save
      redirect_to harvests_path, notice: 'Registro de cosecha creado exitosamente.'
    else
      Rails.logger.debug "Errores: #{@harvest.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def harvest_params
    params.require(:harvest).permit(
      :fecha, :hora, :sector, :variedad,
      :volante_rut, :volante_nombre,
      :encargado_cosecha,
      :cosechero_rut, :cosechero_nombre,
      :cajas, :kilos_por_caja, :calidad,
      :evaluador
    )
  end
end 