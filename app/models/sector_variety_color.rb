class SectorVarietyColor < ApplicationRecord
  belongs_to :sector
  belongs_to :variety
  belongs_to :color

  # Validación opcional para asegurar que el color asignado pertenezca a la variedad
  validate :color_pertenece_a_la_variedad

  private

  def color_pertenece_a_la_variedad
    unless variety.colors.include?(color)
      errors.add(:color, "debe pertenecer a la variedad")
    end
  end
end 