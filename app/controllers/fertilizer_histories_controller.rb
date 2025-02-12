class FertilizerHistoriesController < ApplicationController
  before_action :set_fertilizer, only: [:new, :create]

  # GET /fertilizer_histories
  def index
    @fertilizer_histories = FertilizerHistory.all.order(created_at: :desc)
  end

  # GET /fertilizers/:fertilizer_id/fertilizer_histories/new
  def new
    @fertilizer_history = @fertilizer.fertilizer_histories.new
  end

  # POST /fertilizers/:fertilizer_id/fertilizer_histories
  def create
    @fertilizer_history = @fertilizer.fertilizer_histories.new(fertilizer_history_params)
    @fertilizer_history.usuario = current_user.nombre_completo if current_user
    if @fertilizer_history.save
      redirect_to fertilizers_path, notice: "Historial creado y el fertilizante actualizado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_fertilizer
    if params[:fertilizer_id].present?
      @fertilizer = Fertilizer.find(params[:fertilizer_id])
    end
  end

  def fertilizer_history_params
    params.require(:fertilizer_history).permit(:cantidad_cambiada)
  end
end 