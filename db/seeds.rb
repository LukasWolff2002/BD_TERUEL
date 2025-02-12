# Este archivo se encarga de crear los registros necesarios para que la aplicación funcione en
# cualquier entorno. Es idempotente en el sentido de que se pueden ejecutar varias veces para configurar la base.

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


# Crear colores disponibles
colors = Color.create!([
  { nombre: "Rojo" },
  { nombre: "Verde" },
  { nombre: "Amarillo" },
  { nombre: "Marrón" },
  { nombre: "Rosa" },
  { nombre: "Naranja" }
])

# Crear variedades de tomates
varieties = Variety.create!([
  {
    nombre: "RAF",
    
  },
  {
    nombre: "Corazón de Buey",
   
  },
  {
    nombre: "Cherry",
   
  },
  {
    nombre: "Kumato",
 
  },
  {
    nombre: "Pera",

  },
  {
    nombre: "Rosa",

  }
])

# Asociar colores a cada variedad (relación variety_colors)
varieties.each do |variety|
  # Asignar de 2 a 3 colores aleatorios a la variedad
  assigned_colors = colors.sample(rand(2..3))
  variety.colors = assigned_colors
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

# Mensajes finales de la semilla
puts "Seeds creados exitosamente!"
puts "Se crearon:"
puts "- #{User.count} usuarios"
puts "- #{Sector.count} sectores"
puts "- #{Variety.count} variedades"
puts "- #{Color.count} colores"

# Calcular y mostrar la cantidad de relaciones sector-variedad
total_relations = sectors.map { |sector| sector.varieties.count }.sum
puts "- #{total_relations} relaciones sector-variedad"

# Mostrar cantidad total de asociaciones sector-variedad-color
total_svc = SectorVarietyColor.count
puts "- #{total_svc} relaciones sector-variedad-color"