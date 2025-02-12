class CreateColors < ActiveRecord::Migration[6.1]
  def change
    create_table :colors do |t|
      t.string :nombre, null: false
      t.timestamps
    end
    
    add_index :colors, :nombre, unique: true
  end
end