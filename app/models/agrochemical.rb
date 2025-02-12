class Agrochemical < ApplicationRecord
  belongs_to :agrochemical_division
  has_many :agrochemical_histories, dependent: :destroy

  # Ejemplo de validaciones
  validates :nombre, presence: true
  validates :cantidad, presence: true, numericality: { only_integer: true }
  validates :ingrediente_activo, :objetivo, :ph, :incomatibilidad, :carencias, :reingreso, :daño_a_abejorros, presence: true
end 