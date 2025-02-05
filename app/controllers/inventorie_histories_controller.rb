class InventorieHistoriesController < ApplicationController
  # Muestra el formulario para modificar el inventario
  def index
    # Incluimos los datos de usuario e inventarie para evitar consultas N+1 y ordenamos por fecha descendente.
    @inventorie_histories = InventorieHistory.includes(:user, :inventorie).order(created_at: :desc)
  end

  def new
    @inventorie_history = InventorieHistory.new
  end

  # Procesa el formulario para crear el historial y actualizar el inventario
  def create
    @inventorie_history = InventorieHistory.new(inventorie_history_params)
    ActiveRecord::Base.transaction do
      if @inventorie_history.save
        # Buscamos el registro de inventario correspondiente
        inventorie = Inventorie.find(@inventorie_history.inventorie_id)
        new_quantity = inventorie.cantidad + @inventorie_history.cantidad_cambiada

        # Evitamos que el inventario resulte en un número negativo
        if new_quantity < 0
          @inventorie_history.errors.add(:base, "La cantidad a retirar supera el inventario disponible")
          raise ActiveRecord::Rollback
        end

        # Actualizamos el inventario del artículo
        inventorie.update!(cantidad: new_quantity)
        redirect_to inventories_path, notice: "Inventario modificado correctamente." and return
      else
        render :new, status: :unprocessable_entity and return
      end
    end
  end

  private

  # Se definen los parámetros permitidos
  def inventorie_history_params
    params.require(:inventorie_history).permit(:inventorie_id, :user_id, :cantidad_cambiada, :descripcion)
  end
end