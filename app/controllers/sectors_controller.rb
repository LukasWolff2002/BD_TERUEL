class SectorsController < ApplicationController
  def varieties
    sector = Sector.find(params[:id])
    varieties = sector.varieties.map do |variety|
      {
        id: variety.id,
        nombre: variety.nombre
      }
    end
    
    Rails.logger.debug "Enviando variedades: #{varieties.inspect}"
    render json: varieties
  end
end 