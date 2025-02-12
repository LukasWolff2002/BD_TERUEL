class Sector < ApplicationRecord
  # Relation directa con variedades (via join table sector_varieties)
  has_many :sector_varieties
  has_many :varieties, through: :sector_varieties

  # Relación para determinar qué colores de una variedad están presentes en el sector
  has_many :sector_variety_colors, dependent: :destroy
  has_many :varieties, through: :sector_variety_colors
  has_many :colors, through: :sector_variety_colors

  accepts_nested_attributes_for :varieties, allow_destroy: true
  
  validates :nombre, presence: true
  validates :hectareas, presence: true
end 