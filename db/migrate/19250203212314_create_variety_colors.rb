class CreateVarietyColors < ActiveRecord::Migration[6.1]
  def change
    create_table :variety_colors, id: false do |t|
      t.references :variety, null: false, foreign_key: true
      t.references :color,   null: false, foreign_key: true
    end

    add_index :variety_colors, [:variety_id, :color_id], unique: true
  end
end