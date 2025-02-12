class CreateApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :applications do |t|
      t.integer :temperature
      t.integer :humidity
      t.integer :nubosidad, comment: "Nivel de nubosidad"
      t.integer :viento 

      t.time :hora_inicio
      t.time :hora_fin

      t.date :fecha_aplicacion

      t.string :operador_tractor, comment: "Nombre del operador de tractor (no FK)"

      t.string :aplicadores, comment: "Lista de aplicadores (mínimo 4, separados por comas), sin FK"

      t.string :sector

      t.string :motivo

      t.boolean :uso_de_proteccion

      t.string :observaciones, comment: "Lista de usuarios que realizaron observaciones, sin FK"

      t.string :agroquimicos, comment: "Lista de agroquímicos usados, sin FK"

      t.float :dosificacion

      t.string :maquinaria

      t.date :fecha_de_liberacion

      t.float :mojamiento_relativo

      t.float :mojamiento_real

      t.string :encargado_aplicacion, comment: "Encargado de la aplicación (no FK)"

      t.boolean :lavado_de_equipo
      
      t.timestamps
    end
  end
end
