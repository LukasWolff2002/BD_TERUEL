class ToolHistory < ApplicationRecord
  belongs_to :tool

  validates :usuario, presence: true
  validates :cantidad_cambiada, presence: true, numericality: { only_integer: true }

  # Callback para actualizar la cantidad de la herramienta después de guardar un historial.
  after_create :update_tool_quantity

  private

  def update_tool_quantity
    # Sumar o restar la cantidad según el cambio registrado y actualizar la herramienta.
    new_quantity = tool.cantidad + cantidad_cambiada
    tool.update(cantidad: new_quantity)
  end
end 