class Reception < ApplicationRecord
    
    belongs_to :user, optional: true
    has_one_attached :guia_despacho
    has_many :images, dependent: :destroy
  
    # Definimos las opciones válidas de firmeza y calidad
    FIRMEZA_OPCIONES = ['Blanda', 'Media', 'Firme'].freeze 
    CALIDAD_OPCIONES = ['Bueno', 'Regular', 'Malo'].freeze #Bueno, regular,  malo
  
    # Validaciones
    validates :fecha, presence: true
    validates :hora, presence: true
    
    validates :nro_guia_despacho, presence: true
    validates :pallets, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :cajas, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :kilos_totales, presence: true, numericality: { greater_than: 0 }
  
    # Callback para denormalizar la información del usuario en la recepción,
    # permitiendo conservar dichos datos aunque el usuario se elimine más adelante.
    before_create :copiar_datos_usuario
  
    scope :activos, -> { where(activo: true) }
  
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
  end