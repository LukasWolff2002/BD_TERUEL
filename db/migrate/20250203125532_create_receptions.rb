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
      
      # Campo para almacenar los items de recepción.
      # Cada item es un hash con los siguientes atributos:
      #   "sector"  => nombre del sector (string)
      #   "variety" => nombre de la variedad (string)
      #   "color"   => color (string)
      #   "firmeza" => firmeza del producto (string)
      #   "calidad" => calidad del producto (string)
      #
      # Ejemplo:
      # [
      #   {
      #     "sector" => "Sector A",
      #     "variety" => "Variedad 1",
      #     "color" => "Rojo",
      #     "firmeza" => "Alta",
      #     "calidad" => "Excelente"
      #   },
      #   {
      #     "sector" => "Sector B",
      #     "variety" => "Variedad 2",
      #     "color" => "Verde",
      #     "firmeza" => "Media",
      #     "calidad" => "Buena"
      #   }
      # ]
      t.jsonb :reception_items, null: false, default: []
      
      # Se mantiene la referencia al usuario que registra la recepción.
      t.references :user, null: false, foreign_key: true
      
      # Otros campos propios de la recepción (si son globales)
      t.string  :nro_guia_despacho
      t.integer :pallets
      t.integer :cajas
      t.decimal :kilos_totales, precision: 10, scale: 2
      t.boolean :activo, default: true

      t.timestamps
    end
  end
end