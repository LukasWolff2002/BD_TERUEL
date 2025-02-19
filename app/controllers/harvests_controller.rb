class HarvestsController < ApplicationController
  before_action :require_login
  before_action :load_collections, only: [:new, :create]
  
  def index
    @harvests = Harvest.order(fecha: :desc, hora: :desc)
  end

  def show
    @harvest = Harvest.find(params[:id])
  end

  def new
    @harvest = Harvest.new
    @harvest.fecha = Date.today
    @harvest.hora = Time.current
  end


  def create
    @harvest = Harvest.new(harvest_params)
    
    # Para debugging
    Rails.logger.debug "Parámetros recibidos: #{harvest_params.inspect}"

    if @harvest.save
      redirect_to harvests_path, notice: 'Registro de cosecha creado exitosamente.'
    else
      Rails.logger.debug "Errores: #{@harvest.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @harvest = Harvest.find(params[:id])
  
    if @harvest.destroy
      Rails.logger.info "✅ Cosecha eliminada correctamente"
      redirect_to harvests_path, notice: 'Registro de cosecha eliminado exitosamente.'
    else
      Rails.logger.error "❌ Error al eliminar la cosecha: #{@harvest.errors.full_messages.join(', ')}"
      redirect_to harvests_path, alert: 'No se pudo eliminar el registro de cosecha.'
    end
  end
  

  private

  def load_collections
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
  end


  def harvest_params
    params.require(:harvest).permit(:fecha, :hora, :user, :sector, :variety, :color, :volante_nombre, :cosechero_nombre, :cajas, :kilos_por_caja, :calidad)
  end
  
  
end 