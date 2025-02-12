class AgrochemicalsController < ApplicationController
  before_action :set_agrochemical, only: [:show, :edit, :update, :destroy]

  # GET /agrochemicals
  def index
    @agrochemicals = Agrochemical.all.order(:id)
  end

  # GET /agrochemicals/1
  def show
  end

  # GET /agrochemicals/new
  def new
    @agrochemical = Agrochemical.new
  end

  # POST /agrochemicals
  def create
    @agrochemical = Agrochemical.new(agrochemical_params)
    if @agrochemical.save
      redirect_to agrochemicals_path, notice: 'Agroquímico creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /agrochemicals/1/edit
  def edit
  end

  # PATCH/PUT /agrochemicals/1
  def update
    if @agrochemical.update(agrochemical_params)
      redirect_to @agrochemical, notice: 'Agroquímico actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /agrochemicals/1
  def destroy
    @agrochemical.destroy
    redirect_to agrochemicals_path, notice: 'Agroquímico eliminado exitosamente.'
  end

  private

    def set_agrochemical
      @agrochemical = Agrochemical.find_by(id: params[:id])
      unless @agrochemical
        redirect_to agrochemicals_path, alert: "Agroquímico no encontrado." and return
      end
    end

    def agrochemical_params
      params.require(:agrochemical).permit(:nombre, :cantidad, :ingrediente_activo, :objetivo, :agrochemical_division_id, :ph, :incomatibilidad, :carencias, :reingreso, :daño_a_abejorros)
    end
end 