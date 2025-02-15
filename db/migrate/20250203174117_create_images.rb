class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.references :reception, null: false, foreign_key: true
      t.binary :image
      t.string :filename, null: false # Nombre original del archivo
      t.string :content_type, null: false # Tipo MIME (ej: "image/png", "image/jpeg")

      t.timestamps
    end
  end
end
