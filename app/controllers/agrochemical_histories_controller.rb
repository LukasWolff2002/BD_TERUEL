class AgrochemicalHistoriesController < ApplicationController
  # ApplicationController exige el inicio de sesión mediante require_login

  def index
    @agrochemical_histories = AgrochemicalHistory.includes(:agrochemical).order(created_at: :desc)
  end

  def new
    @agrochemical_history = AgrochemicalHistory.new
  end

  def create
    @agrochemical_history = AgrochemicalHistory.new(agrochemical_history_params)
    # Asignamos el nombre del usuario actual automáticamente, usando current_user.nombre
    nombre_usuario = current_user.nombre.present? ? current_user.nombre : "Sin Nombre"
    @agrochemical_histories = nil  # para prevenir conflictivos en caso de errores (opcional)
    @agrochemical_history.usuario = nombre_usuario

    # Solo se permite aumentar la cantidad; la cantidad a modificar debe ser mayor que 0
    if @agrochemical_history.cantidad_cambiada <= 0
      @agrochemical_history.errors.add(:cantidad_cambiada, "debe ser un número positivo para aumentar el inventario.")
      return render :new, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      if @agrochemical_history.save
        # Buscamos el agroquímico correspondiente
        agrochemical = Agrochemical.find(@agrochemical_history.agrochemical_id)
        nueva_cantidad = agrochemical.cantidad + @agrochemical_history.cantidad_cambiada

        # Actualizamos la cantidad del agroquímico (no se permite disminuir, por lo que no se chequea si queda negativo)
        agrochemical.update!(cantidad: nueva_cantidad)
        redirect_to agrochemicals_path, notice: "Inventario modificado correctamente. Nueva cantidad: #{nueva_cantidad}" and return
      else
        render :new, status: :unprocessable_entity and return
      end
    end
  end

  private

  def agrochemical_history_params
    params.require(:agrochemical_history).permit(:agrochemical_id, :cantidad_cambiada)
  end
end 