class CreateInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventories do |t|
      t.string  :nombre,      null: false
      t.text    :descripcion, null: false
      t.integer :cantidad,    default: 0

      #Agregar tipo de producto
      #Agregar unidad de medida

      #Generar dos tablas de inventario, una de agroquimicos y otra de bodega de herraminetas y otra de fertilizante

      #En agroquimicos separar los prudctos en las siguientes diviciones
      

      #El nombre del agroquimico debe ser perteneciente a una tabla unica

      #Tabla agroquimicos
      #nombre comercial
      #ingrediente activo
      #objetivo, texto
      #division
      #ph
      #incomatibilidad con otros productos
      #carencias
      #reingreso
      #daño a abejorros


      #Generar una tabla de division
      #Herbicidas, Acaricidas, Fungicidas, Insecticidas, Nematicidas, Rodenticidas, Coadyuvantes
      
      t.timestamps
    end
  end
end