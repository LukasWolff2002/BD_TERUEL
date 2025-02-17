class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      # Fechas y datos principales
      t.date     :fecha_aplicacion
      t.date     :fecha_de_liberacion

      # Relativos a operador/aplicadores
      t.string   :operador_tractor
      # Almacena un array de strings (p.ej., ["Juan", "María", "Pedro", "Ana"])
      t.string   :aplicadores, array: true, default: []

      # Sector y hectáreas
      t.string   :sector
      t.float    :hectareas

      # Motivo, observaciones y maquinaria
      t.string   :motivo
      t.text     :observaciones
      t.string   :maquinaria

      # Agroquímicos: array de strings, dosis_en_100_l: array de floats
      t.string   :agroquimicos, array: true, default: []
      t.float    :dosis_en_100_l, array: true, default: []

      # Seguridad
      t.boolean  :uso_de_proteccion, default: false
      t.boolean  :lavado_de_equipo,  default: false

      # Datos para cálculos (mojamiento, clima, etc.)
      t.float    :mojamiento_relativo
      t.float    :mojamiento_real
      t.float    :temperature
      t.float    :humidity
      t.float    :nubosidad
      t.float    :viento

      # Horario de aplicación
      t.datetime :hora_inicio
      t.datetime :hora_fin

      # Encargado de la aplicación (nombre string)
      t.string   :encargado_aplicacion

      t.timestamps
    end
  end
end
