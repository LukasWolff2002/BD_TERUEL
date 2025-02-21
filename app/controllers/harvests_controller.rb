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

  def chart_sectors
    @fecha_inicio = params[:fecha_inicio].present? ? Date.parse(params[:fecha_inicio]) : 7.days.ago.to_date
    @fecha_fin = params[:fecha_fin].present? ? Date.parse(params[:fecha_fin]) : Date.today
  
    Rails.logger.info "📅 Rango de fechas: #{@fecha_inicio} - #{@fecha_fin}"
  
    # Obtener kilos cosechados por fecha y sector
    harvests = Harvest.where(fecha: @fecha_inicio..@fecha_fin)
                      .group(:sector, :fecha)
                      .sum("cajas * kilos_por_caja")
  
    # Inicializar estructura para acumulación
    @data = {}
    sectores = harvests.keys.map(&:first).uniq
    fechas = (@fecha_inicio..@fecha_fin).to_a
  
    # Inicializar la estructura con 0 para cada sector y fecha
    sectores.each do |sector|
      @data[sector] = {}
      acumulado = 0
  
      fechas.each do |fecha|
        kilos_del_dia = harvests[[sector, fecha]] || 0
        acumulado += kilos_del_dia
        @data[sector][fecha] = acumulado
      end
    end
  
    Rails.logger.info "📊 Datos acumulados por sector en el tiempo: #{@data.inspect}"
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