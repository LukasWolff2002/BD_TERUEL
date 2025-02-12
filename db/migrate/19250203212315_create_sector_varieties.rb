class CreateSectorVarieties < ActiveRecord::Migration[6.1]
  def change
    create_table :sector_varieties, id: false do |t|
      t.references :sector,  null: false, foreign_key: true
      t.references :variety, null: false, foreign_key: true
    end

    add_index :sector_varieties, [:sector_id, :variety_id], unique: true
  end
end