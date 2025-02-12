class FertilizersController < ApplicationController
  before_action :set_fertilizer, only: [:show, :edit, :update, :destroy]

  # GET /fertilizers
  def index
    @fertilizers = Fertilizer.all.order(:nombre)
  end

  # GET /fertilizers/1
  def show
  end

  # GET /fertilizers/new
  def new
    @fertilizer = Fertilizer.new
  end

  # POST /fertilizers
  def create
    @fertilizer = Fertilizer.new(fertilizer_params)
    if @fertilizer.save
      redirect_to fertilizers_path, notice: "Fertilizante creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /fertilizers/1/edit
  def edit
  end

  # PATCH/PUT /fertilizers/1
  def update
    if @fertilizer.update(fertilizer_params)
      redirect_to fertilizer_path(@fertilizer), notice: "Fertilizante actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /fertilizers/1
  def destroy
    @fertilizer.destroy
    redirect_to fertilizers_path, notice: "Fertilizante eliminado exitosamente."
  end

  private

  def set_fertilizer
    @fertilizer = Fertilizer.find(params[:id])
  end

  def fertilizer_params
    params.require(:fertilizer).permit(:nombre, :cantidad)
  end
end 