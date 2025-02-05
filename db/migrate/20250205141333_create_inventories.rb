class CreateInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventories do |t|
      t.string  :nombre,      null: false
      t.text    :descripcion
      t.integer :cantidad,    default: 0

      t.timestamps
    end
  end
end