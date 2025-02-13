class CreateReceptions < ActiveRecord::Migration[7.1]
  def change
    create_table :receptions do |t|
      t.date    :fecha,              null: false
      t.time    :hora,               null: false
      t.string  :nro_guia_despacho,  null: false

      # Se elimina el almacenamiento de pallets y cajas a nivel global.
      # Ahora estos datos se guardarán dentro de cada item en el campo JSONB.
      
      t.decimal :kilos_totales,      precision: 10, scale: 2, null: false, default: 0.0
      t.jsonb   :reception_items,    default: [], null: false

      # Datos del proveedor (denormalizados)
      t.integer :supplier_id
      t.string  :supplier_nombre
      t.string  :supplier_rut

      # Relación con el usuario que crea la recepción
      t.integer :user_id

      t.boolean :activo,             default: true

      t.timestamps
    end

    add_index :receptions, :supplier_id
  end
end