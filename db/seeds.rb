# Este archivo se encarga de crear los registros necesarios para que la aplicación funcione en
# cualquier entorno. Es idempotente en el sentido de que se pueden ejecutar varias veces para configurar la base.

puts "Reiniciando la base de datos..."

# Eliminamos registros sin disparar callbacks para evitar problemas con asociaciones incorrectas.
SectorVarietyColor.delete_all
VarietyColor.delete_all
Sector.delete_all

Color.delete_all
Variety.delete_all
User.delete_all
Supplier.delete_all
Agrochemical.delete_all
AgrochemicalDivision.delete_all
Tool.delete_all
Fertilizer.delete_all

puts "Creando usuarios..."
User.create!([
  {
    nombre: "Juan",
    apellido: "Pérez",
    rut: "12.345.678-9",
    email: "juan.perez@example.com",
    cargo: "Administrativo",
    contrato: "interno"
  },
  {
    nombre: "María",
    apellido: "González",
    rut: "87.654.321-0",
    email: "maria.gonzalez@example.com",
    cargo: "Jefe de Campo",
    contrato: "externo"
  },
  {
    nombre: "Carlos",
    apellido: "Sánchez",
    rut: "11.111.111-1",
    email: "carlos.sanchez@example.com",
    cargo: "Jefe Tecnico",
    contrato: "interno"
  },
  {
    nombre: "Ana",
    apellido: "Martinez",
    rut: "22.222.222-2",
    email: "ana.martinez@example.com",
    cargo: "Jefe Packing",
    contrato: "externo"
  },
  {
    nombre: "Luis",
    apellido: "Hernandez",
    rut: "33.333.333-3",
    email: "luis.hernandez@example.com",
    cargo: "Jefe Volante",
    contrato: "interno"
  },
  {
    nombre: "Sofía",
    apellido: "Ramirez",
    rut: "44.444.444-4",
    email: "sofia.ramirez@example.com",
    cargo: "Riego",
    contrato: "externo"
  },
  {
    nombre: "Diego",
    apellido: "Lopez",
    rut: "55.555.555-5",
    email: "diego.lopez@example.com",
    cargo: "Cosechador",
    contrato: "interno"
  },
  {
    nombre: "Camila",
    apellido: "Flores",
    rut: "66.666.666-6",
    email: "camila.flores@example.com",
    cargo: "Volante",
    contrato: "externo"
  },
  {
    nombre: "Andrés",
    apellido: "Gutierrez",
    rut: "77.777.777-7",
    email: "andres.gutierrez@example.com",
    cargo: "Administrativo",
    contrato: "interno"
  },
  {
    nombre: "Valentina",
    apellido: "Morales",
    rut: "88.888.888-8",
    email: "valentina.morales@example.com",
    cargo: "Jefe de Campo",
    contrato: "externo"
  }
])

# Creamos las divisiones de agroquímicos
divisions = AgrochemicalDivision.create!([
  { division: "Fungicidas" },
  { division: "Herbicidas" },
  { division: "Insecticidas" },
  { division: "Reguladores de Crecimiento" }
])

Fertilizer.create!(nombre: "Nitrogen", cantidad: 50)
Fertilizer.create!(nombre: "Phosphorus", cantidad: 30)
Fertilizer.create!(nombre: "Potassium", cantidad: 20)

# Creamos los agroquímicos con todos los atributos requeridos
Agrochemical.create!([
  {
    nombre: "Fungicida Alpha",
    cantidad: 100,
    ingrediente_activo: "Clorotalonil",
    objetivo: "Control de hongos en frutas y vegetales",
    agrochemical_division: divisions.find { |d| d.division == "Fungicidas" },
    ph: 5,
    incomatibilidad: "Incompatible con productos a base de cobre",
    carencias: "Ninguna",
    reingreso: 7,
    daño_a_abejorros: "Bajo impacto"
  },
  {
    nombre: "Herbicida Bravo",
    cantidad: 200,
    ingrediente_activo: "Glifosato",
    objetivo: "Eliminación de malezas de hoja ancha",
    agrochemical_division: divisions.find { |d| d.division == "Herbicidas" },
    ph: 6,
    incomatibilidad: "No mezclar con fertilizantes nitrogenados",
    carencias: "Ninguna",
    reingreso: 10,
    daño_a_abejorros: "Alto impacto"
  },
  {
    nombre: "Insecticida Charlie",
    cantidad: 150,
    ingrediente_activo: "Imidacloprid",
    objetivo: "Control de insectos chupadores",
    agrochemical_division: divisions.find { |d| d.division == "Insecticidas" },
    ph: 7,
    incomatibilidad: "Incompatible con aceites hortícolas",
    carencias: "Ninguna",
    reingreso: 5,
    daño_a_abejorros: "Muy alto"
  },
  {
    nombre: "Regulador Delta",
    cantidad: 80,
    ingrediente_activo: "Etephon",
    objetivo: "Regulación del crecimiento y maduración",
    agrochemical_division: divisions.find { |d| d.division == "Reguladores de Crecimiento" },
    ph: 5,
    incomatibilidad: "No combinar con algunos fungicidas",
    carencias: "Suplementar calcio",
    reingreso: 12,
    daño_a_abejorros: "Medio"
  },
  {
    nombre: "Fungicida Echo",
    cantidad: 120,
    ingrediente_activo: "Mancozeb",
    objetivo: "Prevención de enfermedades fúngicas en granos",
    agrochemical_division: divisions.find { |d| d.division == "Fungicidas" },
    ph: 4,
    incomatibilidad: "No combinar con insecticidas piretroides",
    carencias: "Ninguna",
    reingreso: 8,
    daño_a_abejorros: "Bajo impacto"
  },
  {
    nombre: "Herbicida Foxtrot",
    cantidad: 250,
    ingrediente_activo: "2,4-D",
    objetivo: "Control rápido de malezas de crecimiento acelerado",
    agrochemical_division: divisions.find { |d| d.division == "Herbicidas" },
    ph: 6,
    incomatibilidad: "Incompatible con reguladores de crecimiento",
    carencias: "Ninguna",
    reingreso: 9,
    daño_a_abejorros: "Impacto medio"
  }
])

Supplier.create!([
  {
    nombre: "Agricola Teruel",
    rut: "12.345.678-9"
  },
  {
    nombre: "Supplier 2",
    rut: "87.654.321-0"
  }
])

# Crear registros en la tabla tools
Tool.create!(nombre: "Hammer", cantidad: 10)
Tool.create!(nombre: "Screwdriver", cantidad: 15)
Tool.create!(nombre: "Wrench", cantidad: 7)
Tool.create!(nombre: "Drill", cantidad: 4)

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