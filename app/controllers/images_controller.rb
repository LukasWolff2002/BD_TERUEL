class ImagesController < ApplicationController
    def index
      @images = Image.all
    end

    def show
        @image = Image.find(params[:id])
    end



    private

    def image_params
      params.require(:image).permit(:title, :description, :image, :user_id)
    end
  end