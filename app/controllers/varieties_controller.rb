class VarietiesController < ApplicationController
  def index
    @varieties = Variety.order(:nombre)
  end

  def show
    @variety = Variety.find(params[:id])
  end

  def new
    @variety = Variety.new
  end

  def create
    @variety = Variety.new(variety_params)
    if @variety.save
      redirect_to varieties_path, notice: 'Variedad creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @variety = Variety.find(params[:id])
  end

  def update
    @variety = Variety.find(params[:id])
    if @variety.update(variety_params)
      redirect_to varieties_path, notice: 'Variedad actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @variety = Variety.find(params[:id])
    @variety.destroy
    redirect_to varieties_path, notice: 'Variedad eliminada exitosamente.'
  end

  private

  def variety_params
    params.require(:variety).permit(:nombre, :descripcion, :color)
  end
end 