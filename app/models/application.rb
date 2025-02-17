
class Application < ApplicationRecord
  


  MAQUINARIA_OPCIONES = ["Tractor con nebulizadora", "Pulverizadora", "Máquina de espalda"].freeze

  
  
  
  validate :minimum_aplicadores
  
  before_save :calculate_mojamiento_real
  before_save :calculate_fecha_de_liberacion


  
  def minimum_aplicadores
    if aplicadores.size < 4
      errors.add(:aplicadores, "debe contener al menos 4 usuarios")
    end
  end

  def calculate_mojamiento_real
    if mojamiento_relativo && hectareas
      self.mojamiento_real = mojamiento_relativo * hectareas
    end
  end

  #Para eliminar si queda un aplicador en blanco

  def aplicadores=(value)
    if value.is_a?(Array)
      # Elimina elementos vacíos
      value = value.reject(&:blank?)
    end
    super(value)
  end

  def calculate_fecha_de_liberacion

  end
  
end
