# Este archivo se encarga de crear los registros necesarios para que la aplicación funcione en
# cualquier entorno. Es idempotente en el sentido de que se pueden ejecutar varias veces para configurar la base.

puts "Reiniciando la base de datos..."

# Eliminamos registros sin disparar callbacks para evitar problemas con asociaciones incorrectas.
SectorVarietyColor.delete_all
Sector.delete_all
Variety.delete_all
Color.delete_all
User.delete_all

puts "Creando usuarios..."
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
    rut: "87.654.321-0",
    cargo: "Administrativo",
    contrato: "externo"
  }
])

puts "Creando variedades..."
variety1 = Variety.create!(nombre: "Variedad 1")
variety2 = Variety.create!(nombre: "Variedad 2")
variety3 = Variety.create!(nombre: "Variedad 3")

puts "Creando colores..."
color_rojo     = Color.create!(nombre: "Rojo")
color_verde    = Color.create!(nombre: "Verde")
color_azul     = Color.create!(nombre: "Azul")
color_amarillo = Color.create!(nombre: "Amarillo")

puts "Asociando colores a las variedades..."
# Asociar los colores a las variedades para asegurar que la validación se cumpla
variety1.colors << color_rojo   unless variety1.colors.exists?(color_rojo.id)
variety1.colors << color_verde  unless variety1.colors.exists?(color_verde.id)

variety2.colors << color_azul   unless variety2.colors.exists?(color_azul.id)

variety3.colors << color_amarillo  unless variety3.colors.exists?(color_amarillo.id)
variety3.colors << color_rojo        unless variety3.colors.exists?(color_rojo.id)

puts "Creando sectores..."
sector_a = Sector.create!(nombre: "Sector A", hectareas: 100)
sector_b = Sector.create!(nombre: "Sector B", hectareas: 50)

puts "Creando asociaciones SectorVarietyColor..."
# Para cada asociación se verifica que el color ya esté vinculado a la variedad

if variety1.colors.exists?(color_rojo.id)
  SectorVarietyColor.create!(sector: sector_a, variety: variety1, color: color_rojo)
else
  puts "WARNING: El color #{color_rojo.nombre} no está asociado a la variedad #{variety1.nombre}"
end

if variety1.colors.exists?(color_verde.id)
  SectorVarietyColor.create!(sector: sector_a, variety: variety1, color: color_verde)
else
  puts "WARNING: El color #{color_verde.nombre} no está asociado a la variedad #{variety1.nombre}"
end

if variety2.colors.exists?(color_azul.id)
  SectorVarietyColor.create!(sector: sector_b, variety: variety2, color: color_azul)
else
  puts "WARNING: El color #{color_azul.nombre} no está asociado a la variedad #{variety2.nombre}"
end

if variety3.colors.exists?(color_amarillo.id)
  SectorVarietyColor.create!(sector: sector_b, variety: variety3, color: color_amarillo)
else
  puts "WARNING: El color #{color_amarillo.nombre} no está asociado a la variedad #{variety3.nombre}"
end

if variety3.colors.exists?(color_rojo.id)
  SectorVarietyColor.create!(sector: sector_a, variety: variety3, color: color_rojo)
else
  puts "WARNING: El color #{color_rojo.nombre} no está asociado a la variedad #{variety3.nombre}"
end

puts "Seed completado exitosamente!"