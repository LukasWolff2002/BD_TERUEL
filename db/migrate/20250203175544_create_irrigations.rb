class CreateIrrigations < ActiveRecord::Migration[7.1]
  def change
    create_table :irrigations do |t|
      t.date :fecha #Obligatorio
      t.time :hora #Obligatorio
      t.string :user #Obligatorio
      t.string :sector #Obligatorio
      t.integer :nro_pulsos #Obligatorio
      t.decimal :tiempo_pulso, precision: 5, scale: 2  #Obligatorio
      
      # Riego de entrada
      t.decimal :riego_entrada_mm, precision: 5, scale: 2 #Obligatorio
      t.decimal :riego_entrada_ph, precision: 4, scale: 2 #Obligatorio
      t.decimal :riego_entrada_ce, precision: 5, scale: 2 #Obligatorio
      t.decimal :riego_entrada_nitratos, precision: 6, scale: 2 #Obligatorio
      t.decimal :riego_entrada_potasio, precision: 6, scale: 2 #Obligatorio
      
      # Drenaje de riego
      t.decimal :drenaje_riego_mm, precision: 5, scale: 2 #Se puede dejar nulo
      t.decimal :drenaje_riego_ph, precision: 4, scale: 2 #Se puede dejar nulo
      t.decimal :drenaje_riego_ce, precision: 5, scale: 2 #Se puede dejar nulo
      t.decimal :drenaje_riego_nitratos, precision: 6, scale: 2 #Se puede dejar nulo
      t.decimal :drenaje_riego_potasio, precision: 6, scale: 2  #Se puede dejar nulo
      
      # Mediciones iniciales y finales
      t.decimal :humedad_inicial, precision: 5, scale: 2 #Se puede dejar nulo
      t.decimal :ce_inicial, precision: 5, scale: 2 #Se puede dejar nulo
      t.decimal :humedad_final, precision: 5, scale: 2  #Se puede dejar nulo
      t.decimal :ce_final, precision: 5, scale: 2 #Se puede dejar nulo
      
      # Pulsos con agua
      t.integer :pulsos_agua #Se puede dejare nulo
      t.decimal :tiempo_pulsos_agua, precision: 5, scale: 2   #Se puede dejar nulo
      
      # Mediciones hoja
      t.decimal :potasio_hoja, precision: 6, scale: 2 #Se puede dejar nulo
      t.decimal :nitratos_hoja, precision: 6, scale: 2 #Se puede dejar nulo
      
      # Otros
      t.decimal :porcentaje_drenaje, precision: 5, scale: 2  # Se puede dejar nulo
      t.integer :muestras #Se puede dejar nulo

      t.timestamps
    end
  end
end 