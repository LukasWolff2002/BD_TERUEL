class AgrochemicalHistory < ApplicationRecord
  belongs_to :agrochemical

  # Validaciones para asegurar que se guarde la información requerida
  validates :usuario, presence: true
  validates :cantidad_cambiada, presence: true
end 