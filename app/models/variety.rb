class Variety < ApplicationRecord
  # Relación con colores disponibles para la variedad
  has_many :variety_colors, dependent: :destroy
  has_many :colors, through: :variety_colors

  # Relación con sectores en los que la variedad está presente
  has_many :sector_varieties
  has_many :sectors, through: :sector_varieties

  # Relación para identificar en qué sectores y con qué colores se usa la variedad
  has_many :sector_variety_colors

  validates :nombre, presence: true
end