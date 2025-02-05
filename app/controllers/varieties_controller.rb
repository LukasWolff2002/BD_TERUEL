class VarietiesController < ApplicationController
  def show
    variety = Variety.find(params[:id])
    render json: variety
  end
end 