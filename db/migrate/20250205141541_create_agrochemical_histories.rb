class CreateAgrochemicalHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :agrochemical_histories do |t|
      # Se guarda el nombre o identificador del usuario de forma literal, sin 
      # establecer una relación foránea, para preservar el historial aun si se elimina el usuario.
      t.string :usuario, null: false, comment: "Nombre o identificador del usuario que realizó el cambio"
      
      t.references :agrochemical, null: false, foreign_key: true
      t.integer :cantidad_cambiada, null: false, comment: "Cantidad agregada (valor positivo) o cantidad removida (valor negativo)"

      t.timestamps
    end
  end
end
