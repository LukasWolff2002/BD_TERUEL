class ToolsController < ApplicationController
  before_action :set_tool, only: [:show, :edit, :update, :destroy]

  # GET /tools
  def index
    @tools = Tool.all.order(:nombre)
  end

  # GET /tools/1
  def show
  end

  # GET /tools/new
  def new
    @tool = Tool.new
  end

  # POST /tools
  def create
    @tool = Tool.new(tool_params)
    if @tool.save
      redirect_to tools_path, notice: "Herramienta creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /tools/1/edit
  def edit
  end

  # PATCH/PUT /tools/1
  def update
    if @tool.update(tool_params)
      redirect_to tool_path(@tool), notice: "Herramienta actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tools/1
  def destroy
    @tool.destroy
    redirect_to tools_path, notice: "Herramienta eliminada exitosamente."
  end

  private

  # Utiliza callbacks para compartir la lógica de encontrar herramienta.
  def set_tool
    @tool = Tool.find(params[:id])
  end

  # Solo permite un listado seguro de parámetros.
  def tool_params
    params.require(:tool).permit(:nombre, :cantidad)
  end
end 