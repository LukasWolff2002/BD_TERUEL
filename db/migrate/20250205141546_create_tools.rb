class CreateTools < ActiveRecord::Migration[6.1]
  def change
    create_table :tools do |t|
      t.string  :nombre,      null: false
      t.integer :cantidad,    default: 0
      
      t.timestamps
    end
  end
end