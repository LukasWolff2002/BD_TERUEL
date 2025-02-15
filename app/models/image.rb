class Image < ApplicationRecord
  belongs_to :reception

  validates :reception, presence: true
  validates :image, presence: true
  validates :filename, presence: true
  validates :content_type, presence: true
  validate :acceptable_image_size, :acceptable_image_format

  private

  # Validar tamaño de la imagen (máximo 5MB)
  def acceptable_image_size
    if image.present? && image.bytesize > 5.megabytes
      errors.add(:image, "debe ser menor a 5MB")
    end
  end

  # Validar formato de la imagen (solo PNG y JPEG)
  def acceptable_image_format
    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(content_type)
      errors.add(:image, "debe ser un JPEG o PNG")
    end
  end
end
