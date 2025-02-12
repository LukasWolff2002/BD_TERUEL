class CreateVarieties < ActiveRecord::Migration[7.1]
  def change
    create_table :varieties do |t|
      t.string :nombre

      t.timestamps
    end

    add_index :varieties, :nombre, unique: true
  end
end