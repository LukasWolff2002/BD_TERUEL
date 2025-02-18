class Harvest < ApplicationRecord
  CALIDAD_OPCIONES = ['Primera', 'Segunda', 'Tercera'].freeze

  # Validaciones
  validates :calidad, presence: true, inclusion: { in: CALIDAD_OPCIONES }
  validates :fecha, presence: true
  validates :hora, presence: true
  validates :sector, presence: true
  validates :volante_nombre, presence: true
  validates :cosechero_nombre, presence: true
  validates :variety, presence: true
  validates :cajas, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :kilos_por_caja, presence: true, numericality: { greater_than: 0 }

  # Callbacks para convertir IDs a nombres antes de guardar
  before_save :convert_sector_variety_to_name
  before_save :calcular_kilos_tomates

  private

  # Método para convertir IDs de sector y variedad en nombres
  def convert_sector_variety_to_name
    self.sector = Sector.find_by(id: sector)&.nombre || sector
    self.variety = Variety.find_by(id: variety)&.nombre || variety
  end

  # Método para calcular kilos_tomates antes de guardar
  def calcular_kilos_tomates
    if cajas.to_i >= 0 && kilos_por_caja.to_f > 0
      self.kilos_tomates = cajas * kilos_por_caja
    else
      self.kilos_tomates = 0 # Evita valores nulos o erróneos
    end
  end
end
