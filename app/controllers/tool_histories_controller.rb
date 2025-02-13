class ToolHistoriesController < ApplicationController
  # No se requiere before_action para set_tool en index, ya que se listan todos los históricos.
  before_action :set_tool, only: [:new, :create]

  # GET /tool_histories
  def index
    @tool_histories = ToolHistory.all.order(created_at: :desc)
  end

  # GET /tools/:tool_id/tool_histories/new
  def new
    @tool_history = @tool.tool_histories.new
  end

  # POST /tools/:tool_id/tool_histories
  def create
    @tool_history = @tool.tool_histories.new(tool_history_params)
    @tool_history.usuario = current_user.nombre_completo
    if @tool_history.save
      redirect_to tool_tool_histories_path(@tool), notice: "Historial creado y la herramienta actualizada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_tool
    if params[:tool_id].present?
      @tool = Tool.find(params[:tool_id])
    end
  end

  def tool_history_params
    params.require(:tool_history).permit(:cantidad_cambiada)
  end
end 