class Irrigation < ApplicationRecord
  belongs_to :sector
  belongs_to :user

  validates :fecha, presence: true
  validates :hora, presence: true
  validates :sector_id, presence: true
  validates :encargado_de_riego_id, presence: true
  validates :nro_pulsos, presence: true, numericality: { greater_than: 0 }
  validates :tiempo_pulso, presence: true, numericality: { greater_than: 0 }
  # ... otras validaciones ...
end 