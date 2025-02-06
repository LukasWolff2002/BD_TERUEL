class SectorsController < ApplicationController
  before_action :set_sector, only: [:edit, :update, :destroy, :edit_varieties, :update_varieties]

  def index
    @sectors = Sector.includes(:varieties).order(:nombre)
  end

  def new
    @sector = Sector.new
  end
  
  def create
    @sector = Sector.new(sector_params)
    if @sector.save
      redirect_to sectors_path, notice: 'Sector creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @sector.update(sector_params)
      redirect_to sectors_path, notice: 'Sector actualizado correctamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sector.destroy
    redirect_to sectors_path, notice: 'Sector eliminado correctamente.'
  end

  # Acción para presentar el formulario para agregar/quitar asociaciones de variedades
  def edit_varieties
    # @sector se carga en el callback
  end

  # Acción para actualizar las asociaciones de variedades
  def update_varieties
    if params[:sector] && params[:sector][:varieties_attributes]
      # Extraemos las asociaciones desde el hash enviado.
      # Cada entrada debe tener el atributo "id" (con el id de la variedad a asociar)
      # y, opcionalmente, el flag _destroy si se marca para eliminación.
      varieties_params = params[:sector][:varieties_attributes]
      
      # Recorremos los atributos, descartamos aquellos que tengan _destroy marcado
      # y extraemos el id (descartamos entradas en blanco).
      new_ids = varieties_params.values.reject { |attr| attr["_destroy"] == "1" }
                                      .map { |attr| attr["id"] }
                                      .reject(&:blank?)
      
      if @sector.update(variety_ids: new_ids)
        redirect_to sectors_path, notice: 'Variedades actualizadas correctamente.'
      else
        render :edit_varieties, status: :unprocessable_entity
      end
    else
      redirect_to sectors_path, notice: 'No se realizaron cambios.'
    end
  end

  def varieties
    sector = Sector.find(params[:id])
    varieties = sector.varieties.map do |variety|
      {
        id: variety.id,
        nombre: variety.nombre
      }
    end
    
    Rails.logger.debug "Enviando variedades: #{varieties.inspect}"
    render json: varieties
  end

  private

  def set_sector
    @sector = Sector.find(params[:id])
  end

  def sector_params
    # Se permite un array de variety_ids para la asociación HABTM.
    params.require(:sector).permit(:nombre, :descripcion, variety_ids: [])
  end

  # Ya no es necesario un método de parámetros anidados para variedades ya que
  # la actualización se realiza manualmente en update_varieties.
end 