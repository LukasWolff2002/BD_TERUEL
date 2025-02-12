class AgrochemicalDivisionsController < ApplicationController
  before_action :set_agrochemical_division, only: [:show, :edit, :update, :destroy]

  # GET /agrochemical_divisions
  def index
    @agrochemical_divisions = AgrochemicalDivision.all.order(:id)
  end

  # GET /agrochemical_divisions/1
  def show
  end

  # GET /agrochemical_divisions/new
  def new
    @agrochemical_division = AgrochemicalDivision.new
  end

  # POST /agrochemical_divisions
  def create
    @agrochemical_division = AgrochemicalDivision.new(agrochemical_division_params)
    if @agrochemical_division.save
      redirect_to agrochemical_divisions_path, notice: 'División agroquímica creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /agrochemical_divisions/1/edit
  def edit
  end

  # PATCH/PUT /agrochemical_divisions/1
  def update
    if @agrochemical_division.update(agrochemical_division_params)
      redirect_to agrochemical_division_path(@agrochemical_division), notice: 'División agroquímica actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /agrochemical_divisions/1
  def destroy
    @agrochemical_division.destroy
    redirect_to agrochemical_divisions_path, notice: 'División agroquímica eliminada exitosamente.'
  end

  private

    def set_agrochemical_division
      @agrochemical_division = AgrochemicalDivision.find(params[:id])
    end

    def agrochemical_division_params
      params.require(:agrochemical_division).permit(:division)
    end
end 