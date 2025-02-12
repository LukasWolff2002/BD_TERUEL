class FertilizerHistory < ApplicationRecord
  belongs_to :fertilizer

  validates :usuario, presence: true
  validates :cantidad_cambiada, presence: true, numericality: { only_integer: true }

  # Callback para actualizar la cantidad del fertilizante cuando se crea un historial.
  after_create :update_fertilizer_quantity

  private

  def update_fertilizer_quantity
    new_quantity = fertilizer.cantidad + cantidad_cambiada
    fertilizer.update(cantidad: new_quantity)
  end
end 