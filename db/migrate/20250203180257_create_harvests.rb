class CreateHarvests < ActiveRecord::Migration[7.1]
  def change
    create_table :harvests do |t|
      t.date :fecha
      t.time :hora
      t.string :user # Se mantiene como string sin referencia a users
      t.string :sector
      t.string :variety
      t.string :color
      
      # Información del cargo
      t.string :volante_nombre
      
      # Información del cosechero
      t.string :cosechero_nombre
      
      t.integer :cajas, default: 0, null: false
      t.decimal :kilos_por_caja, precision: 5, scale: 2
      t.string :calidad # Usar la misma calidad que en recepciones
      t.decimal :kilos_tomates, precision: 8, scale: 2  # Se calculará en el modelo

      t.timestamps
    end

    # Índices para búsquedas frecuentes
    add_index :harvests, :fecha
  end
end
