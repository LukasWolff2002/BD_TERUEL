class SectorsController < ApplicationController
  before_action :set_sector, only: [:edit, :update, :destroy]

  def index
    @sectors = Sector.all.order(:nombre)
  end

  def new
    @sector = Sector.new
  end
  
  def create
    @sector = Sector.new(sector_params)
    if @sector.save
      redirect_to sectors_path, notice: "Sector creado exitosamente."
    else
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