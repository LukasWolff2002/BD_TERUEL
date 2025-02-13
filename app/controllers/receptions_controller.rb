class ReceptionsController < ApplicationController
  # Se asegura que estas variables se carguen en nuevas recepciones o cuando hay errores en create
  before_action :load_collections, only: [:new, :create]

  def index
    @receptions = Reception.activos.order(created_at: :desc)
  end

  def show
    @reception = Reception.find(params[:id])
  end

  def new
    @reception = Reception.new
    @reception.fecha = Date.today
    @reception.hora  = Time.current
  end

  def create
    @reception = Reception.new(reception_params)

    if @reception.save
      redirect_to @reception, notice: 'Recepción creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Acción para el informe con filtros
  def informe
    @receptions = Reception.all

    # Filtrar por rango de fechas
    if params[:fecha_inicio].present? && params[:fecha_fin].present?
      @receptions = @receptions.where(fecha: params[:fecha_inicio]..params[:fecha_fin])
    elsif params[:fecha_inicio].present?
      @receptions = @receptions.where("fecha >= ?", params[:fecha_inicio])
    elsif params[:fecha_fin].present?
      @receptions = @receptions.where("fecha <= ?", params[:fecha_fin])
    end

    # Filtrar por sector (usando JOIN con la tabla sectors)
    if params[:sector].present?
      @receptions = @receptions.joins(:sector).where("sectors.nombre ILIKE ?", "%#{params[:sector]}%")
    end

    # Filtrar por nombre (búsqueda parcial sobre el campo 'nombre' de Reception)
    if params[:nombre].present?
      @receptions = @receptions.where("nombre ILIKE ?", "%#{params[:nombre]}%")
    end

    @receptions = @receptions.order(fecha: :desc)

    respond_to do |format|
      format.html
      format.xlsx do
        response.headers["Content-Disposition"] = "attachment; filename=recepciones_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
      end
    end
  end

  private

  def load_collections
    # Carga de sectores para proveedor Agricola Teruel
    @sectors = Sector.includes(varieties: :colors).all
    @varieties_by_sector = @sectors.each_with_object({}) do |sector, hash|
      hash[sector.id] = sector.varieties.distinct.map do |variety|
        colors = Color.joins(:sector_variety_colors)
                      .where(sector_variety_colors: { sector_id: sector.id, variety_id: variety.id })
                      .distinct
                      .pluck(:nombre)
        { id: variety.id, nombre: variety.nombre, colors: colors }
      end
    end

    # Para proveedores distintos a Agricola Teruel, se listan todas las variedades globalmente
    @all_varieties = Variety.includes(:colors).distinct.map do |variety|
      { id: variety.id, nombre: variety.nombre, colors: variety.colors.pluck(:nombre).uniq }
    end

    # Cargar la lista de proveedores
    @suppliers = Supplier.all
  end

  def reception_params
    # Procesamos el arreglo de reception_items para asegurarnos
    # de que contenga siempre las claves :pallets, :cajas y :kilos.
    raw_params = params.require(:reception).to_unsafe_h
    raw_params["reception_items"] = Array.wrap(raw_params["reception_items"]).map do |item|
      item = item.to_h.stringify_keys
      item["pallets"] = "0" if item["pallets"].blank?
      item["cajas"]   = "0" if item["cajas"].blank?
      item["kilos"]   = "0" if item["kilos"].blank?
      item
    end

    ActionController::Parameters.new(raw_params).permit(
      :fecha,
      :hora,
      :user_id,
      :nro_guia_despacho,
      :guia_despacho,
      :supplier_id,
      reception_items: [:sector, :variety, :color, :firmeza, :calidad, :pallets, :cajas, :kilos]
    )
  end
end