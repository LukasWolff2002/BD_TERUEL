class SectorsController < ApplicationController
  before_action :set_sector, only: [:edit, :update, :destroy]

  def index
    @sectors = Sector.all.order(:nombre)
  end

  def show
    @sector = Sector.find(params[:id])
  end

  def new
    @sector = Sector.new
  end
  
  def create
    @sector = Sector.new(sector_params)
    if @sector.save
      Rails.logger.info "Sector creado: #{@sector.inspect}"
      # Procesamos las asociaciones de variedades y colores
      if params[:sector][:sector_variety_color_assignments].present?
        params[:sector][:sector_variety_color_assignments].each do |variety_id, color_ids|
          # Convertimos los IDs a enteros y eliminamos valores en blanco
          color_ids = color_ids.reject(&:blank?).map(&:to_i)
          Rails.logger.info "Variety ID #{variety_id}: Color IDs recibidos: #{color_ids.inspect}"
          next if color_ids.empty?

          variety = Variety.find_by(id: variety_id.to_i)
          unless variety
            Rails.logger.warn "Variety id #{variety_id} no encontrada"
            next
          end

          color_ids.each do |color_id|
            color = Color.find_by(id: color_id)
            if color && variety.colors.exists?(id: color.id)
              SectorVarietyColor.create!(sector: @sector, variety: variety, color: color)
              Rails.logger.info "Creada asociación: Sector #{@sector.id} - Variedad #{variety.id} - Color #{color.id}"
            else
              Rails.logger.warn "El color #{color_id} no pertenece a la variedad #{variety.nombre}"
            end
          end
        end
      else
        Rails.logger.info "No se enviaron asociaciones de variedades y colores."
      end
      redirect_to sectors_path, notice: "Sector creado exitosamente."
    else
      Rails.logger.error "Error al crear sector: #{@sector.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Gracias al before_action, @sector ya está asignado
  end

  def update
    if @sector.update(sector_params)
      # Proceder a actualizar las asociaciones sin usar @sector.variety_ids=
      @sector.sector_variety_colors.destroy_all

      if params[:sector][:sector_variety_color_assignments].present?
        params[:sector][:sector_variety_color_assignments].each do |variety_id, color_ids|
          color_ids = color_ids.reject(&:blank?).map(&:to_i)
          next if color_ids.empty?
          variety = Variety.find_by(id: variety_id.to_i)
          next unless variety.present?

          color_ids.each do |color_id|
            color = Color.find_by(id: color_id)
            if color && variety.colors.exists?(id: color_id)
              SectorVarietyColor.create!(sector: @sector, variety: variety, color: color)
            else
              Rails.logger.warn "El color #{color_id} no pertenece a la variedad #{variety.nombre}"
            end
          end
        end
      end

      redirect_to sectors_path, notice: "Sector actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sector.destroy
    redirect_to sectors_path, notice: "Sector eliminado exitosamente."
  end

  private

  def set_sector
    @sector = Sector.find(params[:id])
  end

  def sector_params
    params.require(:sector).permit(:nombre, :hectareas)
  end

end 