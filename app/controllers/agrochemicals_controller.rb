class AgrochemicalsController < ApplicationController
  def index
    @agrochemicals = Agrochemical.includes(:agrochemical_division).all
  end

  def new
    @agrochemical = Agrochemical.new
  end

  def create
    @agrochemical = Agrochemical.new(agrochemical_params)
    if @agrochemical.save
      redirect_to agrochemicals_path, notice: 'Agroquímico creado exitosamente.'
    else
      render :new
    end
  end

  private

  def agrochemical_params
    params.require(:agrochemical).permit(
      :nombre,
      :cantidad,
      :ingrediente_activo,
      :objetivo,
      :agrochemical_division_id,
      :ph,
      :incomatibilidad,
      :carencias,
      :reingreso,
      :daño_a_abejorros
    )
  end
end 