class Irrigation < ApplicationRecord
  # Eliminamos las asociaciones para que "user" y "sector" sean simples campos de texto
  # belongs_to :sector, optional: true
  # belongs_to :user, optional: true

  validates :fecha, presence: true
  validates :hora, presence: true
  validates :user, presence: true    # Ahora se valida que el campo 'user' (que almacenará el id en forma de string) esté presente
  validates :sector, presence: true  # Igual para 'sector'
  validates :nro_pulsos, presence: true
  validates :tiempo_pulso, presence: true
  # ... otras validaciones ...

  # Devuelve el nombre completo del usuario basado en el id almacenado en la columna "user".
  # Se asume que el campo "user" almacena el id del usuario (aunque sea como string).
  def evaluador
    # Convierte a entero en caso de que sea necesario (o usa el valor directamente)
    user_record = User.find_by(id: self.user)
    user_record ? user_record.nombre_completo : "Usuario desconocido"
  end

  # Devuelve el nombre del sector basado en el id almacenado en la columna "sector".
  def sector_nombre
    sector_record = Sector.find_by(id: self.sector)
    sector_record ? sector_record.nombre : "Sector desconocido"
  end
end
