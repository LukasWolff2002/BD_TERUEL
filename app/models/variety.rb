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
  validates :p_supermercado, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :p_feria, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :p_descarte, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  validates :v_supermercado, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :v_feria, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :v_descarte, numericality: { greater_than_or_equal_to: 0}, allow_nil: true

  # Callback para calcular p_descarte antes de guardar
  before_validation :calcular_p_descarte

  private

  def calcular_p_descarte
    if p_supermercado.present? && p_feria.present?
      self.p_descarte = 100.0 - (p_supermercado.to_f + p_feria.to_f)
    end
  end
end
