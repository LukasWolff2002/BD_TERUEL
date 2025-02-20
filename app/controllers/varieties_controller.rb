class VarietiesController < ApplicationController
  before_action :set_variety, only: %i[show edit update destroy]

  def index
    @varieties = Variety.all.order(:nombre)
  end

  def show
    @variety = Variety.find(params[:id])
  end

  def new
    @variety = Variety.new
  end

  def create
    @variety = Variety.new(variety_params)
    Rails.logger.info "Intentando crear variedad con params: #{variety_params.inspect}" 

    if @variety.save
      Rails.logger.info "Variedad creada exitosamente: #{@variety.inspect}"
      redirect_to varieties_path, notice: 'Variedad creada exitosamente.'
    else
      Rails.logger.error "Error al crear la variedad: #{@variety.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.fatal "Excepción en Variety#create: #{e.message}\n#{e.backtrace.join("\n")}"
    raise
  end

  def edit
    @variety = Variety.find(params[:id])
  end

  def update
    @variety = Variety.find(params[:id])
    if @variety.update(variety_params)
      redirect_to varieties_path, notice: 'Variedad actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @variety = Variety.find(params[:id])
    @variety.destroy
    redirect_to varieties_path, notice: 'Variedad eliminada exitosamente.'
  end

  private

  def variety_params
    params.require(:variety).permit(:nombre, :p_supermercado, :p_feria, :p_descarte, :v_supermercado, :v_feria, :v_descarte, color_ids: [])
  end

  def set_variety
    @variety = Variety.find(params[:id])
  end
end 