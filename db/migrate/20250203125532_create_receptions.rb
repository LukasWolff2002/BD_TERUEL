class CreateReceptions < ActiveRecord::Migration[7.1]
  def change
    create_table :receptions do |t|
      #Una recepcion puede ser interna o externa, si es externa no trabaja sector, es decir, se selecciona directamente la variedad
      #Agregar una clave que sea proveedor, por lo tanto hay que crear una tabla llamada provedor

      #Tabla provedor
      #nombre del proveedor
      #rut del proveedor

      t.date :fecha, null: false
      t.time :hora, null: false
      t.references :sector, null: false, foreign_key: true
      #En una recepcion pueden haber multiples variedades
      t.references :variety, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :color
      t.string :nro_guia_despacho
      t.string :firmeza
      t.string :calidad #modificar la calidad
      
      t.integer :pallets
      t.integer :cajas
      #Los palets y las cajas son por el total

      t.decimal :kilos_cajas, precision: 5, scale: 2 #Eliminar esta columna
      t.decimal :kilos_totales, precision: 10, scale: 2  # Agregamos esta columna
      #Los kilos totales son por cada variedad
      t.boolean :activo, default: true

      t.timestamps
    end
  end
end