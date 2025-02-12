class ApplicationsController < ApplicationController
  def index
    @applications = Application.all.order(created_at: :desc)
  end

  def new
    @application = Application.new
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

  def application_params
    params.require(:application).permit(
      :temperature, :humidity, :nubosidad, :viento,
      :hora_inicio, :hora_fin, :fecha_aplicacion, :operador_tractor,
      :aplicadores, :sector, :motivo, :uso_de_proteccion, :observaciones,
      :agroquimicos, :dosificacion, :maquinaria, :mojamiento_relativo,
      :encargado_aplicacion, :lavado_de_equipo, :dosis_en_100_l, :hectareas
    )
  end
end 