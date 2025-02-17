class Application < ApplicationRecord
  MAQUINARIA_OPCIONES = ["Tractor con nebulizadora", "Pulverizadora", "Máquina de espalda"].freeze

  # Validaciones
  validates :fecha_aplicacion, presence: true
  validates :operador_tractor, presence: true
  validates :sector, presence: true
  validates :hectareas, presence: true, numericality: { greater_than: 0 }
  validates :maquinaria, inclusion: { in: MAQUINARIA_OPCIONES, message: "debe ser una opción válida" }, allow_blank: true
  validate :minimum_aplicadores

  # Callbacks
  before_save :calculate_mojamiento_real
  before_save :calculate_fecha_de_liberacion
  after_create :register_agrochemical_usage

  # Validación personalizada
  def minimum_aplicadores
    if aplicadores.blank? || aplicadores.size < 4
      errors.add(:aplicadores, "debe contener al menos 4 usuarios")
    end
  end

  # Calcula el mojamiento real basado en hectáreas
  def calculate_mojamiento_real
    return if mojamiento_relativo.blank? || hectareas.blank?

    self.mojamiento_real = mojamiento_relativo * hectareas
  end

  # Calcula la fecha de liberación en base al reingreso más alto de los agroquímicos
  def calculate_fecha_de_liberacion
    return if fecha_aplicacion.blank? || agroquimicos.blank?

    agroquimicos_usados = Agrochemical.where(nombre: agroquimicos)
    max_reingreso = agroquimicos_usados.maximum(:reingreso) || 0

    self.fecha_de_liberacion = fecha_aplicacion + max_reingreso.days
  end

  # Registra el uso de agroquímicos y descuenta del inventario
  def register_agrochemical_usage
    puts "🔥 register_agrochemical_usage se está ejecutando"
  
    agroquimicos.each_with_index do |agroquimico_nombre, index|
      agroquimico = Agrochemical.find_by(nombre: agroquimico_nombre)
      
      if agroquimico.nil?
        puts "❌ Error: No se encontró el agroquímico #{agroquimico_nombre}"
        next
      end
  
      cantidad_a_descontar = (mojamiento_real * dosis_en_100_l[index].to_f / 100.0).round
      puts "✅ DESCONTANDO #{cantidad_a_descontar}L de #{agroquimico.nombre} (Stock antes: #{agroquimico.cantidad}L)"
  
      # Crear registro en AgrochemicalHistory
      historial = AgrochemicalHistory.new(
        agrochemical_id: agroquimico.id,
        cantidad_cambiada: -cantidad_a_descontar,
        usuario: "Sistema"
      )
  
      unless historial.save
        puts "❌ ERROR al crear AgrochemicalHistory: #{historial.errors.full_messages.join(", ")}"
        raise ActiveRecord::Rollback, "Error al registrar historial de agroquímicos."
      end
  
      # Actualizar stock del agroquímico
      nuevo_stock = agroquimico.cantidad - cantidad_a_descontar
      if nuevo_stock < 0
        puts "❌ ERROR: No hay suficiente stock de #{agroquimico.nombre}."
        raise ActiveRecord::Rollback, "Stock insuficiente para #{agroquimico.nombre}."
      end
  
      agroquimico.update!(cantidad: nuevo_stock)
      puts "✅ Nuevo stock de #{agroquimico.nombre}: #{agroquimico.cantidad}L"
    end
  end
  
  

  # Limpia la lista de aplicadores para eliminar valores vacíos
  def aplicadores=(value)
    super(Array(value).reject(&:blank?))
  end
end
