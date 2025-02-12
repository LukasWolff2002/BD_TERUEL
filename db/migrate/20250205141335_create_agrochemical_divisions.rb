class CreateAgrochemicalDivisions < ActiveRecord::Migration[6.1]
  def change
    create_table :agrochemical_divisions do |t|
      t.string  :division,      null: false
      
      #Generar una tabla de division
      #Herbicidas, Acaricidas, Fungicidas, Insecticidas, Nematicidas, Rodenticidas, Coadyuvantes
      
      t.timestamps
    end
  end
end