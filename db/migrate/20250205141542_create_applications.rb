class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.date     :fecha_aplicacion
      t.string   :operador_tractor
      t.string   :aplicadores
      t.string   :sector
      t.string   :motivo
      t.boolean  :uso_de_proteccion, default: false
      t.text     :observaciones
      t.string   :agroquimicos
      t.string   :dosis_en_100_l
      t.string   :maquinaria
      t.date     :fecha_de_liberacion
      t.float    :mojamiento_relativo
      t.float    :mojamiento_real
      t.string   :encargado_aplicacion
      t.boolean  :lavado_de_equipo, default: false
      t.float    :temperature
      t.float    :humidity
      t.float    :nubosidad
      t.float    :viento
      t.datetime :hora_inicio
      t.datetime :hora_fin

      t.timestamps
    end
  end
end