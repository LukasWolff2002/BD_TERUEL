class CreateVarieties < ActiveRecord::Migration[7.1]
  def change
    create_table :varieties do |t|
      t.string :nombre
      t.text :descripcion #Eliminar descripcion
      t.string :color #Una variedad puede tener muchos colores

      t.timestamps
    end

    add_index :varieties, :nombre, unique: true
  end
end