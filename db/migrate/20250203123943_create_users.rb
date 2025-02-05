class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :nombre
      t.string :apellido
      t.string :rut
      t.string :cargo
      t.string :contrato #interno o externo
      t.timestamps
    end

    add_index :users, :cargo
    add_index :users, :rut  # También es buena práctica indexar el rut ya que se usará para login
  end
end