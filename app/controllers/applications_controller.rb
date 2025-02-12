class ApplicationsController < ApplicationController
    before_action :set_application, only: [:show]
  def index
    @applications = Application.all.order(created_at: :desc)
  end

  def new
    @application = Application.new
  end

  def show
  end

 
  def create
    @application = Application.new(application_params)
    if @application.save
      redirect_to applications_path, notice: "Aplicación creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_application
    @application = Application.find_by(id: params[:id])
    unless @application
      redirect_to applications_path, alert: "Aplicación no encontrada." and return
    end
  end

  def application_params
    params.require(:application).permit(
      :fecha_aplicacion, :sector, :operador_tractor, :motivo,
      :uso_de_proteccion, :observaciones, :maquinaria, :mojamiento_relativo,
      :hectareas, :encargado_aplicacion, :lavado_de_equipo,
      :temperature, :humidity, :nubosidad, :viento, :hora_inicio, :hora_fin,
      :agroquimicos, # si es una cadena con nombres combinados
      aplicadores: [], # Especifica que este campo es un arreglo
      dosis_en_100_l: []  # Permitir un arreglo de floats para las dosis
    )
  end
end 