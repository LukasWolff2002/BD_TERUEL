class ColorsController < ApplicationController
  def index
    @colors = Color.all.order(:nombre)
  end

  def new
    @color = Color.new
  end

  def create
    @color = Color.new(color_params)
    if @color.save
      redirect_to colors_path, notice: "Color creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @color = Color.find(params[:id])
  end

  def update
    @color = Color.find(params[:id])
    if @color.update(color_params)
      redirect_to colors_path, notice: "Color actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def color_params
    params.require(:color).permit(:nombre)
  end
end 