class Reception < ApplicationRecord
    
    belongs_to :user, optional: true
    belongs_to :supplier, optional: true
    has_one_attached :guia_despacho
    has_many :images, dependent: :destroy
  
    # Definimos las opciones válidas de firmeza y calidad
    FIRMEZA_OPCIONES = ['Blanda', 'Media', 'Firme'].freeze 
    CALIDAD_OPCIONES = ['Primera', 'Segunda', 'Tercera'].freeze #Bueno, regular,  malo
  
    # Validaciones
    validates :fecha, presence: true
    validates :hora, presence: true
    
    validates :nro_guia_despacho, presence: true
    validates :kilos_totales, presence: true, numericality: { greater_than: 0 }
  
    # Callback para denormalizar la información del usuario en la recepción,
    # permitiendo conservar dichos datos aunque el usuario se elimine más adelante.
    before_create :copiar_datos_usuario
  
    scope :activos, -> { where(activo: true) }
  
    # Ejecutar antes de las validaciones para que kilos_totales ya esté asignado.
    before_validation :calculate_global_kilos
  
    def to_s
      "Recepción ##{id}"
    end
  
    private
  
    def copiar_datos_usuario
      return unless user.present?
      self.user_nombre  = user.nombre      if self.respond_to?(:user_nombre)
      self.user_apellido = user.apellido    if self.respond_to?(:user_apellido)
      self.user_rut     = user.rut         if self.respond_to?(:user_rut)
    end

    # Callback para copiar los datos actuales del proveedor seleccionado
    def copiar_datos_supplier
      return unless supplier_id.present?
      supplier_record = Supplier.find_by(id: supplier_id)
      if supplier_record.present?
        self.supplier_nombre = supplier_record.nombre if self.respond_to?(:supplier_nombre)
        self.supplier_rut    = supplier_record.rut if self.respond_to?(:supplier_rut)
      end
    end

    # Recorre cada item de reception_items y suma el valor de "kilos".
    # Se convierte cada item en un hash con acceso indiferente para soportar tanto
    # claves como string o símbolo.
    def calculate_global_kilos
      total = 0.to_d
      Array.wrap(reception_items).each do |item|
        # Aseguramos que cada item es un hash con acceso indiferente.
        h_item = item.is_a?(Hash) ? item.with_indifferent_access : {}
        # Extraemos el valor de "kilos", lo convertimos a string, le hacemos strip y luego a decimal.
        kilos_val = h_item['kilos'].to_s.strip
        total += kilos_val.blank? ? 0.to_d : kilos_val.to_d
      end
      self.kilos_totales = total
    end
  end