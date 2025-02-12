class ReceptionsController < ApplicationController
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
  
    # Carga los sectores junto con sus variedades y los colores asociados
    @sectors = Sector.includes(varieties: :colors).all
  
    # Construye un hash para que cada sector tenga un arreglo de variedades,
    # donde cada variedad es representada por un hash con sus atributos y un arreglo
    # con los nombres de los colores asociados.
    @varieties_by_sector = @sectors.each_with_object({}) do |sector, hash|
      hash[sector.id] = sector.varieties.map do |variety|
        {
          id: variety.id,
          nombre: variety.nombre,
          colors: variety.colors.map(&:nombre)
        }
      end
    end

    # Cargar la lista de proveedores para el select. En cada recepción se elegirá un solo proveedor.
    @suppliers = Supplier.all
  end
  

  def create
    @reception = Reception.new(reception_params)
  
    if @reception.save
      redirect_to @reception, notice: 'Recepción creada exitosamente.'
    else
      # Re-cargar las colecciones necesarias para que el formulario pueda renderizarse 
      # correctamente al presentar errores de validación.
      @sectors = Sector.includes(varieties: :colors).all
      @varieties_by_sector = @sectors.each_with_object({}) do |sector, hash|
        hash[sector.id] = sector.varieties.map do |variety|
          {
            id: variety.id,
            nombre: variety.nombre,
            colors: variety.colors.map(&:nombre)
          }
        end
      end
      @suppliers = Supplier.all
  
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

  def reception_params
    params.require(:reception).permit(
      :fecha,
      :hora,
      :user_id,
      :nro_guia_despacho,
      :pallets,
      :cajas,
      :kilos_totales,
      :guia_despacho,
      :supplier_id,    # Se permite la elección de un único proveedor
      reception_items: [:sector, :variety, :color, :firmeza, :calidad]  # Múltiples productos
    )
  end
end
