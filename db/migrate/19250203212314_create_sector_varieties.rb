class CreateSectorVarieties < ActiveRecord::Migration[7.1]
  def change
    create_table :sector_varieties do |t|
      t.references :sector, null: false, foreign_key: true
      t.references :variety, null: false, foreign_key: true

      t.timestamps
    end

    add_index :sector_varieties, [:sector_id, :variety_id], unique: true
  end
end