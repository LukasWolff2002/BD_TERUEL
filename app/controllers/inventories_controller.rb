class InventoriesController < ApplicationController
 
  def index
    @inventories = Inventorie.all
  end

  def new
    @inventorie = Inventorie.new
  end

  def create
    @inventorie = Inventorie.new(inventorie_params)
    if @inventorie.save
      redirect_to inventories_path, notice: 'Item de inventario creado correctamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def inventorie_params
    params.require(:inventorie).permit(:nombre, :descripcion, :cantidad)
  end
end 