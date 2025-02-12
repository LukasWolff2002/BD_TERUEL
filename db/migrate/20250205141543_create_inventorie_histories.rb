class CreateInventorieHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventorie_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :inventorie, null: false, foreign_key: true
      t.integer :cantidad_cambiada, null: false, comment: "Cantidad agregada (valor positivo) o cantidad removida (valor negativo)"
      t.string :descripcion, null: false

      t.timestamps
    end
  end
end
