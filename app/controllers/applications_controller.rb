# app/controllers/applications_controller.rb
class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :destroy]
  before_action :set_sectors, only: [:new, :create]


  # GET /applications
  def index
    @applications = Application.order(created_at: :desc)
  end

  # GET /applications/:id
  def show
  end

  def preview
    @application = Application.new(application_params)
    # Aquí podrías validar o almacenar temporalmente los datos base si es necesario
  end

  # DELETE /applications/:id
def destroy
  if @application.destroy
    Rails.logger.info "✅ Aplicación eliminada correctamente"
    redirect_to applications_path, notice: "La aplicación fue eliminada correctamente."
  else
    Rails.logger.error "❌ Error al eliminar la aplicación: #{@application.errors.full_messages.join(', ')}"
    redirect_to applications_path, alert: "No se pudo eliminar la aplicación."
  end
end

  

  # GET /applications/new
  def new
    @application = Application.new
    @sectors = Sector.all
  end

  # POST /applications
  def create
    puts "PARAMS RECIBIDOS: #{params[:application].inspect}"
    puts "AGROQUIMICOS RECIBIDOS: #{params[:application][:agroquimicos]}"
    puts "DOSIS RECIBIDAS: #{params[:application][:dosis_en_100_l]}"
    
    @application = Application.new(application_params)
    if @application.save
      redirect_to @application, notice: "La aplicación se creó exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /applications/:id/edit
  def edit
  end

  # PATCH/PUT /applications/:id
  def update
    if @application.update(application_params)
      redirect_to @application, notice: "La aplicación se actualizó correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:id
  def destroy
    @application.destroy
    redirect_to applications_path, notice: "La aplicación fue eliminada."
  end

  private

  # Busca el registro para las acciones que lo requieren
  def set_application
    @application = Application.find(params[:id])
  end

  def set_sectors
    @sectors = Sector.all
  end

  # Strong parameters: se permite un array nativo para los campos que lo requieren
  def application_params
    params.require(:application).permit(
      :fecha_aplicacion,
      :fecha_de_liberacion,
      :operador_tractor,
      :sector,
      :hectareas,
      :motivo,
      :observaciones,
      :maquinaria,
      :uso_de_proteccion,
      :lavado_de_equipo,
      :mojamiento_relativo,
      :mojamiento_real,
      :temperature,
      :humidity,
      :nubosidad,
      :viento,
      :hora_inicio,
      :hora_fin,
      :encargado_aplicacion,
      aplicadores: [],   # <-- Array de strings
      agroquimicos: [],  # <-- Array de strings
      dosis_en_100_l: [] # <-- Array de floats
    )
  end
end
