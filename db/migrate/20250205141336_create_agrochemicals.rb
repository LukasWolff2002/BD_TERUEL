class CreateAgrochemicals < ActiveRecord::Migration[6.1]
  def change
    create_table :agrochemicals do |t|
      t.string  :nombre,      null: false
      t.decimal :cantidad, null: false
      t.text    :ingrediente_activo, null: false
      t.text    :objetivo, null: false
      t.references :agrochemical_division, null: false, foreign_key: true
      t.integer :ph, null: false
      t.text    :incomatibilidad, null: false
      t.text    :carencias, null: false
      t.integer :reingreso, null: false
      t.text    :daño_a_abejorros, null: false

      t.timestamps
    end
  end
end