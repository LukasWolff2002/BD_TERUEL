class CreateSectorsVarieties < ActiveRecord::Migration[7.1]
  def change
    create_table "SectorsVarieties", id: false do |t|
      t.references :sector, null: false, foreign_key: true
      t.references :variety, null: false, foreign_key: true
    end

    add_index "SectorsVarieties", [:sector_id, :variety_id], unique: true
  end
end 