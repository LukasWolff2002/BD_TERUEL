class Reception < ApplicationRecord
    belongs_to :sector
    belongs_to :variety
    belongs_to :user
    has_one_attached :guia_despacho
    has_many :images, dependent: :destroy
  
    # Definimos las opciones válidas de firmeza y calidad
    FIRMEZA_OPCIONES = ['Blanda', 'Media', 'Firme'].freeze
    CALIDAD_OPCIONES = ['Primera', 'Segunda', 'Tercera'].freeze
  
    # Validaciones
    validates :fecha, presence: true
    validates :hora, presence: true
    validates :sector_id, presence: true
    validates :variety_id, presence: true
    validates :user_id, presence: true
    validates :nro_guia_despacho, presence: true
    validates :firmeza, presence: true, inclusion: { in: FIRMEZA_OPCIONES }
    validates :calidad, presence: true, inclusion: { in: CALIDAD_OPCIONES }
    validates :pallets, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :cajas, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :kilos_cajas, presence: true, numericality: { greater_than: 0 }
  
    # Callback para calcular kilos totales antes de guardar
    before_save :calcular_kilos_totales
  
    scope :activos, -> { where(activo: true) }
  
    def to_s
      "Recepción ##{id}"
    end
  
    private
  
    def calcular_kilos_totales
      self.kilos_totales = cajas * pallets * kilos_cajas if cajas && pallets && kilos_cajas
    end
  end