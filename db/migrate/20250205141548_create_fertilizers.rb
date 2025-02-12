class CreateFertilizers < ActiveRecord::Migration[6.1]
  def change
    create_table :fertilizers do |t|
      t.string  :nombre,      null: false
      t.integer :cantidad,    default: 0
      
      t.timestamps
    end
  end
end