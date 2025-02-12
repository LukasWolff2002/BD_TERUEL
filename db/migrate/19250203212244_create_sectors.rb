class CreateSectors < ActiveRecord::Migration[7.1]
  def change
    create_table :sectors do |t|
      t.string :nombre
      t.integer :hectareas

      t.timestamps
    end

    add_index :sectors, :nombre, unique: true
  end
end