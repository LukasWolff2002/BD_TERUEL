class Application < ApplicationRecord
  # Atributo virtual para recibir las hectáreas del sector (no se almacena en la BD)
  attr_accessor :hectareas

  # Validaciones básicas (ajusta según tus requerimientos)
  validates :operador_tractor, :aplicadores, :sector, :motivo, :fecha_aplicacion, presence: true

  # Validación personalizada para que el campo aplicadores contenga al menos 4 usuarios.
  validate :aplicadores_minimum_count

  # Callbacks para calcular el mojamiento_real y la fecha de liberación antes de guardar
  before_save :calculate_mojamiento_real
  before_save :calculate_fecha_de_liberacion

  # Método setter para que, si se asigna un Array a "aplicadores", se convierta en una cadena separada por comas.
  def aplicadores=(value)
    if value.is_a?(Array)
      super(value.join(", "))
    else
      super(value)
    end
  end

  # Métodos helper para manejar campos con listas separadas por comas

  # Devuelve un Array con los nombres de los aplicadores
  def aplicadores_list
    aplicadores.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  # Devuelve un Array con los nombres de los agroquímicos usados
  def agroquimicos_list
    agroquimicos.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  # Devuelve un Array con los nombres de los usuarios que realizaron observaciones
  def observaciones_list
    observaciones.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  # Devuelve un Array con las dosis en 100 L correspondientes a cada producto
  def dosis_en_100_l_list
    dosis_en_100_l.to_s.split(",").map { |dosis| dosis.strip.to_f }
  end

  # Calcula el máximo valor de reingreso entre los agroquímicos usados.
  def max_reingreso
    reingreso_values = agroquimicos_list.map do |nombre|
      agro = Agrochemical.find_by(nombre: nombre)
      agro&.reingreso
    end.compact
    reingreso_values.max
  end

  private

  # Valida que el campo "aplicadores" contenga al menos 4 usuarios.
  def aplicadores_minimum_count
    if aplicadores_list.size < 4
      errors.add(:aplicadores, "debe contener al menos 4 usuarios")
    end
  end

  # Calcula el mojamiento_real como el producto de mojamiento_relativo y las hectáreas.
  def calculate_mojamiento_real
    if mojamiento_relativo.present? && hectareas.present?
      self.mojamiento_real = mojamiento_relativo * hectareas.to_f
    end
  end

  # Calcula la fecha de liberación como fecha_aplicacion + (max reingreso en días).
  def calculate_fecha_de_liberacion
    if fecha_aplicacion.present? && max_reingreso.present?
      self.fecha_de_liberacion = fecha_aplicacion + max_reingreso.to_i
    end
  end
end 