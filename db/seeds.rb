# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Crear usuarios de ejemplo
User.create!([
  {
    nombre: "Juan",
    apellido: "Pérez",
    rut: "12.345.678-9",
    cargo: "Administrativo",
    contrato: "interno"
  },
  {
    nombre: "María",
    apellido: "González",
    rut: "11.222.333-4",
    cargo: "Jefe de Campo",
    contrato: "interno"
  },
  {
    nombre: "Carlos",
    apellido: "Rodríguez",
    rut: "14.555.666-7",
    cargo: "Jefe Tecnico",
    contrato: "interno"
  },
  {
    nombre: "Ana",
    apellido: "Martínez",
    rut: "13.777.888-5",
    cargo: "Jefe Packing",
    contrato: "interno"
  },
  {
    nombre: "Pedro",
    apellido: "Sánchez",
    rut: "15.999.000-1",
    cargo: "Riego",
    contrato: "externo"
  },
  {
    nombre: "Laura",
    apellido: "Muñoz",
    rut: "16.111.222-3",
    cargo: "Cosechador",
    contrato: "externo"
  },
  {
    nombre: "Diego",
    apellido: "Silva",
    rut: "17.333.444-5",
    cargo: "Volante",
    contrato: "externo"
  }
])

# Crear sectores
sectors = Sector.create!([
  {
    nombre: "Invernadero 1",
    descripcion: "Invernadero principal con sistema de riego automatizado"
  },
  {
    nombre: "Invernadero 2",
    descripcion: "Invernadero secundario con control de temperatura"
  },
  {
    nombre: "Invernadero 3",
    descripcion: "Invernadero experimental para nuevas variedades"
  },
  {
    nombre: "Invernadero 4",
    descripcion: "Invernadero de producción intensiva"
  },
  {
    nombre: "Invernadero 5",
    descripcion: "Invernadero de propagación y semilleros"
  }
])

# Crear variedades de tomates
varieties = Variety.create!([
  {
    nombre: "RAF",
    descripcion: "Tomate de sabor intenso y dulce, muy apreciado en alta cocina",
    color: "Verde oscuro a marrón"
  },
  {
    nombre: "Corazón de Buey",
    descripcion: "Tomate grande y carnoso, ideal para ensaladas",
    color: "Rojo intenso"
  },
  {
    nombre: "Cherry",
    descripcion: "Tomate pequeño y dulce, perfecto para snacks",
    color: "Rojo brillante"
  },
  {
    nombre: "Kumato",
    descripcion: "Tomate de color oscuro y sabor dulce",
    color: "Marrón oscuro"
  },
  {
    nombre: "Pera",
    descripcion: "Tomate alargado ideal para salsas",
    color: "Rojo"
  },
  {
    nombre: "Rosa",
    descripcion: "Tomate de color rosado y sabor suave",
    color: "Rosa"
  }
])

# Crear relaciones entre sectores y variedades
# Usamos la asociación HABTM definida en Sector (y automáticamente se insertará en la tabla SectorsVarieties)
sectors.each do |sector|
  # Asignar 2-3 variedades aleatorias a cada sector
  varieties.sample(rand(2..3)).each do |variety|
    sector.varieties << variety unless sector.varieties.include?(variety)
  end
end

# Crear inventarios
Inventorie.create!([
  {
    nombre: "Producto A",
    descripcion: "Inventario base para Producto A",
    cantidad: 100
  },
  {
    nombre: "Producto B",
    descripcion: "Inventario base para Producto B",
    cantidad: 50
  },
  {
    nombre: "Producto C",
    descripcion: "Inventario base para Producto C",
    cantidad: 25
  }
])
puts "Inventarios iniciales cargados exitosamente."

puts "Seeds creados exitosamente!"
puts "Se crearon:"
puts "- #{User.count} usuarios"
puts "- #{Sector.count} sectores"
puts "- #{Variety.count} variedades"

# Para mostrar la cantidad de relaciones añadidas, sumamos las asociaciones de cada sector
total_relations = sectors.map { |sector| sector.varieties.count }.sum
puts "- #{total_relations} relaciones sector-variedad"