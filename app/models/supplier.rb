class Supplier < ApplicationRecord
  # Validaciones básicas
  validates :nombre, presence: true
  validates :rut, presence: true, uniqueness: true

  # Método para mostrar el nombre del proveedor en listas/selections, por ejemplo:
  def to_s
    nombre
  end
end 