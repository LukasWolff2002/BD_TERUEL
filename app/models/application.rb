class Application < ApplicationRecord
  # Atributo virtual para las hectáreas (no se almacena en la BD)
  attr_accessor :hectareas

  # Validaciones básicas
  validates :operador_tractor, :aplicadores, :sector, :motivo, :fecha_aplicacion, presence: true

  # Validación para que el campo aplicadores contenga al menos 4 usuarios.
  validate :aplicadores_minimum_count

  # Callbacks para calcular mojamiento_real y fecha_de_liberacion
  before_save :calculate_mojamiento_real
  before_save :calculate_fecha_de_liberacion

  # Setter para aplicadores (convierte arreglo a cadena)
  def aplicadores=(value)
    if value.is_a?(Array)
      super(value.join(", "))
    else
      super(value)
    end
  end

  # Agrega un setter para dosis_en_100_l para convertir arreglo a cadena
  def dosis_en_100_l=(value)
    if value.is_a?(Array)
      super(value.join(", "))
    else
      super(value)
    end
  end

  # Métodos helper para convertir en listas (arreglos)
  def aplicadores_list
    aplicadores.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  def agroquimicos_list
    agroquimicos.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  def observaciones_list
    observaciones.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  def dosis_en_100_l_list
    dosis_en_100_l.to_s.split(",").map { |dosis| dosis.strip.to_f }
  end

  def max_reingreso
    reingreso_values = agroquimicos_list.map do |nombre|
      agro = Agrochemical.find_by(nombre: nombre)
      agro&.reingreso
    end.compact
    reingreso_values.max
  end

  private

  def aplicadores_minimum_count
    if aplicadores_list.size < 4
      errors.add(:aplicadores, "debe contener al menos 4 usuarios")
    end
  end

  def calculate_mojamiento_real
    if mojamiento_relativo.present? && hectareas.present?
      self.mojamiento_real = mojamiento_relativo * hectareas.to_f
    end
  end

  def calculate_fecha_de_liberacion
    if fecha_aplicacion.present? && max_reingreso.present?
      self.fecha_de_liberacion = fecha_aplicacion + max_reingreso.to_i
    end
  end
end 