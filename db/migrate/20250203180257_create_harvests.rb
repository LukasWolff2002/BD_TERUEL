class CreateHarvests < ActiveRecord::Migration[7.1]
  def change
    create_table :harvests do |t|
      t.date :fecha
      t.time :hora
      t.references :user, null: false, foreign_key: true
      t.references :sector, null: false, foreign_key: true
      t.references :variety, null: false, foreign_key: true
      
      # Información del cargo
      t.string :volante_rut
      t.string :volante_nombre
      
      t.string :encargado_cosecha
      
      # Información del cosechero
      t.string :cosechero_rut
      t.string :cosechero_nombre
      
      t.integer :cajas
      t.decimal :kilos_por_caja, precision: 5, scale: 2
      t.string :calidad
      t.decimal :kilos_tomates, precision: 8, scale: 2  # Campo calculado

      t.timestamps
    end

    # Índices para búsquedas frecuentes
    add_index :harvests, :fecha
    add_index :harvests, :volante_rut
    add_index :harvests, :cosechero_rut
  end
end
