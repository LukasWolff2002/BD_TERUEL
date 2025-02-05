class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.references :reception, null: false, foreign_key: true

      t.timestamps
    end
  end
end
