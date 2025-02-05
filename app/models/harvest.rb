class Harvest < ApplicationRecord
  belongs_to :user
  
  # Validaciones
  validates :fecha, presence: true
  validates :hora, presence: true
  validates :sector, presence: true
  validates :cargo_rut, presence: true
  validates :cargo_nombre, presence: true
  validates :encargado_cosecha, presence: true
  validates :cosechero_rut, presence: true
  validates :cosechero_nombre, presence: true
  validates :variedad, presence: true
  validates :cajas, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :kilos_por_caja, presence: true, numericality: { greater_than: 0 }
  validates :calidad, presence: true
  
  
  # Validación de formato RUT chileno (XX.XXX.XXX-X)
  validates :cargo_rut, :cosechero_rut, format: { 
    with: /\A\d{1,2}\.\d{3}\.\d{3}[-][0-9kK]{1}\z/, 
    message: "debe tener formato válido (XX.XXX.XXX-X)" 
  }

  # Callback para calcular kilos_tomates antes de guardar
  before_save :calcular_kilos_tomates

  private

  def calcular_kilos_tomates
    if cajas.present? && kilos_por_caja.present?
      self.kilos_tomates = cajas * kilos_por_caja
    end
  end
end 