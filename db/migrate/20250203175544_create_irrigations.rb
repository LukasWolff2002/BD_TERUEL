class CreateIrrigations < ActiveRecord::Migration[7.1]
  def change
    create_table :irrigations do |t|
      t.date :fecha #Al momento de creacion de recepcion
      t.time :hora #Al momento de creacion de recepcion
      t.references :encargado_de_riego, foreign_key: { to_table: :users }
      t.references :sector, foreign_key: true  # Forma correcta de crear la referenci
      t.integer :nro_pulsos
      t.decimal :tiempo_pulso, precision: 5, scale: 2  # minutos con decimales
      
      # Riego de entrada
      t.decimal :riego_entrada_mm, precision: 5, scale: 2
      t.decimal :riego_entrada_ph, precision: 4, scale: 2
      t.decimal :riego_entrada_ce, precision: 5, scale: 2
      t.decimal :riego_entrada_nitratos, precision: 6, scale: 2
      t.decimal :riego_entrada_potasio, precision: 6, scale: 2
      
      # Drenaje de riego
      t.decimal :drenaje_riego_mm, precision: 5, scale: 2
      t.decimal :drenaje_riego_ph, precision: 4, scale: 2
      t.decimal :drenaje_riego_ce, precision: 5, scale: 2
      t.decimal :drenaje_riego_nitratos, precision: 6, scale: 2
      t.decimal :drenaje_riego_potasio, precision: 6, scale: 2
      
      # Mediciones iniciales y finales
      t.decimal :humedad_inicial, precision: 5, scale: 2  # porcentaje
      t.decimal :ce_inicial, precision: 5, scale: 2
      t.decimal :humedad_final, precision: 5, scale: 2    # porcentaje
      t.decimal :ce_final, precision: 5, scale: 2
      
      # Pulsos con agua
      t.integer :pulsos_agua
      t.decimal :tiempo_pulsos_agua, precision: 5, scale: 2  # minutos
      
      # Mediciones hoja
      t.decimal :potasio_hoja, precision: 6, scale: 2
      t.decimal :nitratos_hoja, precision: 6, scale: 2
      
      # Otros
      t.decimal :porcentaje_drenaje, precision: 5, scale: 2  # porcentaje
      t.integer :muestras

      t.timestamps
    end
  end
end 