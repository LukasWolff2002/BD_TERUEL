class Supplier < ApplicationRecord
  # Validaciones básicas
  before_validation :normalizar_campos
  
  validates :nombre, presence: true
  validates :rut, presence: true, uniqueness: true

  # Método para mostrar el nombre del proveedor en listas/selections, por ejemplo:
  def to_s
    nombre
  end

  private

  def normalizar_campos
    normalizar_rut
  end

  # 1. Normalizar RUT
  def normalizar_rut
    return if rut.blank?

    # Eliminar todo carácter que no sea dígito ni k/K y convertir a minúscula
    rut_sanitizado = rut.gsub(/[^0-9kK]/, '').downcase

    return if rut_sanitizado.blank? # Si no queda nada, no hace nada

    cuerpo = rut_sanitizado[0..-2] # Todo menos el último carácter
    dv     = rut_sanitizado[-1]    # Último carácter (puede ser dígito o 'k')

    # Formatear el cuerpo con puntos cada 3 dígitos (de derecha a izquierda)
    cuerpo_formateado = cuerpo.reverse.scan(/\d{1,3}/).join('.').reverse

    # Asignar en formato "XX.XXX.XXX-DV"
    self.rut = "#{cuerpo_formateado}-#{dv}"
  end
end 