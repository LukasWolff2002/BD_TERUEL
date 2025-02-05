class IrrigationsController < ApplicationController
  before_action :set_irrigation, only: [:show, :edit, :update, :destroy]

  def index
    @irrigations = Irrigation.includes(:encargado_de_riego).order(created_at: :desc)
  end

  def show
    @irrigation = Irrigation.find(params[:id])
  end

  def new
    @irrigation = Irrigation.new
    @irrigation.fecha = Date.today
    @irrigation.hora = Time.now
  end

  def create
    @irrigation = Irrigation.new(irrigation_params)
    
    if @irrigation.save
      redirect_to irrigations_path, notice: 'Registro de riego creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @irrigation.update(irrigation_params)
      redirect_to irrigations_path, notice: 'Registro de riego actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @irrigation.destroy
    redirect_to irrigations_path, notice: 'Registro de riego eliminado exitosamente.'
  end

  private

  def set_irrigation
    @irrigation = Irrigation.find(params[:id])
  end

  def irrigation_params
    params.require(:irrigation).permit(
      :user_id, :sector, :nro_pulsos, :tiempo_pulso,
      :riego_entrada_mm, :riego_entrada_ph, :riego_entrada_ce, 
      :riego_entrada_nitratos, :riego_entrada_potasio,
      :drenaje_riego_mm, :drenaje_riego_ph, :drenaje_riego_ce,
      :drenaje_riego_nitratos, :drenaje_riego_potasio,
      :humedad_inicial, :ce_inicial, :humedad_final, :ce_final,
      :pulsos_agua, :tiempo_pulsos_agua,
      :potasio_hoja, :nitratos_hoja,
      :porcentaje_drenaje, :muestras
    )
  end
end 