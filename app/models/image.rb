class Image < ApplicationRecord
    belongs_to :reception
    has_one_attached :image
    
    validates :reception, presence: true
    validates :image, presence: true
    validate :acceptable_image
  
    private
  
    def acceptable_image
      return unless image.attached?
  
      unless image.blob.byte_size <= 5.megabyte
        errors.add(:image, "debe ser menor a 5MB")
      end
  
      acceptable_types = ["image/jpeg", "image/png"]
      unless acceptable_types.include?(image.content_type)
        errors.add(:image, "debe ser un JPEG o PNG")
      end
    end
  end