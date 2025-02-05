class ImagesController < ApplicationController
    def index
      @images = Image.all.includes(:reception).order(created_at: :desc)
      
      # Para debugging, agrega esto temporalmente:
      Rails.logger.debug "Número de imágenes encontradas: #{@images.count}"
      @images.each do |image|
        Rails.logger.debug "Image ID: #{image.id}, Reception ID: #{image.reception_id}, Tiene imagen adjunta: #{image.image.attached?}"
      end
    end



    private

    def image_params
      params.require(:image).permit(:title, :description, :image, :user_id)
    end
  end