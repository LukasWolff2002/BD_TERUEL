class CreateReceptions < ActiveRecord::Migration[7.1]
  def change
    create_table :receptions do |t|
      t.date :fecha, null: false
      t.time :hora, null: false
      t.references :sector, null: false, foreign_key: true
      t.references :variety, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :color
      t.string :nro_guia_despacho
      t.string :firmeza
      t.string :calidad
      t.integer :pallets
      t.integer :cajas
      t.decimal :kilos_cajas, precision: 5, scale: 2
      t.decimal :kilos_totales, precision: 10, scale: 2  # Agregamos esta columna
      t.boolean :activo, default: true

      t.timestamps
    end
  end
end