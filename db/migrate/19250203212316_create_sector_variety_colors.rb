class CreateSectorVarietyColors < ActiveRecord::Migration[6.1]
  def change
    create_table :sector_variety_colors do |t|
      t.references :sector,  null: false, foreign_key: true
      t.references :variety, null: false, foreign_key: true
      t.references :color,   null: false, foreign_key: true

    end
    
    add_index :sector_variety_colors, [:sector_id, :variety_id, :color_id], unique: true, name: 'index_sector_variety_colors_on_all'
  end
end