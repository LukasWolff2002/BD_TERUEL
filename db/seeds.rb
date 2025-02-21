require 'faker'

puts "Reiniciando la base de datos..."

# Eliminamos registros sin disparar callbacks
SectorVarietyColor.delete_all
VarietyColor.delete_all
Sector.delete_all
Image.delete_all
Reception.delete_all
Harvest.delete_all
Color.delete_all
Variety.delete_all
User.delete_all
Supplier.delete_all
Agrochemical.delete_all
AgrochemicalDivision.delete_all
Tool.delete_all
FertilizerHistory.delete_all
Fertilizer.delete_all

puts "Creando usuarios..."
users = User.create!([
  { nombre: "Juan", apellido: "Pérez", rut: "12.345.678-9", email: "juan.perez@example.com", cargo: "Administrativo", contrato: "interno" },
  { nombre: "María", apellido: "González", rut: "87.654.321-0", email: "maria.gonzalez@example.com", cargo: "Jefe de Campo", contrato: "externo" }
])

puts "Creando proveedores..."
suppliers = Supplier.create!([
  { nombre: "Agrícola Teruel", rut: "12.345.678-9" },
  { nombre: "Supplier 2", rut: "87.654.321-0" }
])

puts "Creando variedades..."
varieties = Variety.create!([
  { nombre: "Variedad 1", p_supermercado: 40, p_feria: 30, p_descarte: 30, v_supermercado: 100, v_feria: 50, v_descarte: 50 },
  { nombre: "Variedad 2", p_supermercado: 20, p_feria: 50, p_descarte: 30, v_supermercado: 80, v_feria: 60, v_descarte: 40 },
  { nombre: "Variedad 3", p_supermercado: 10, p_feria: 20, p_descarte: 70, v_supermercado: 70, v_feria: 30, v_descarte: 60 }
])

puts "Creando colores..."
colors = Color.create!([
  { nombre: "Rojo" },
  { nombre: "Verde" },
  { nombre: "Azul" },
  { nombre: "Amarillo" }
])

puts "Asociando colores a las variedades..."
varieties.each do |variety|
  assigned_colors = colors.sample(rand(1..2)) # Cada variedad tendrá 1 o 2 colores aleatorios
  variety.colors << assigned_colors
end

puts "Creando sectores..."
sectors = Sector.create!([
  { nombre: "Sector A", hectareas: 100 },
  { nombre: "Sector B", hectareas: 50 },
  { nombre: "Sector C", hectareas: 75 }
])

puts "Creando asociaciones SectorVarietyColor..."
sectors.each do |sector|
  varieties.sample(2).each do |variety|
    variety.colors.each do |color|
      SectorVarietyColor.create!(sector: sector, variety: variety, color: color)
    end
  end
end


puts "Generando cosechas..."

# Obtener datos existentes

# Definir datos de referencia
sectores = ["Sector A", "Sector B", "Sector C"]
variedades = ["Variedad 1", "Variedad 2", "Variedad 3"]
colores = ["Rojo", "Verde", "Azul", "Amarillo"]
calidades = ["Primera", "Segunda", "Tercera"]
usuarios = ["Juan Pérez", "María González", "Carlos Sánchez", "Ana Martinez"]
volantes = ["Luis Hernández", "Sofía Ramirez", "Diego Lopez"]
cosecheros = ["Andrés Gutierrez", "Valentina Morales", "Camila Flores"]

# Crear cosechas en diferentes fechas
30.times do |i|
  fecha = Faker::Date.between(from: 1.week.ago, to: Date.today)
  hora = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)

  harvest = Harvest.new(
    fecha: fecha,
    hora: hora,
    user: usuarios.sample,
    sector: sectores.sample,
    variety: variedades.sample,
    color: colores.sample,
    volante_nombre: volantes.sample,
    cosechero_nombre: cosecheros.sample,
    cajas: rand(5..20), # Entre 5 y 20 cajas
    kilos_por_caja: rand(5.0..10.0).round(2), # Entre 5 y 10 kilos por caja
    calidad: calidades.sample
  )

  if harvest.save
    puts "✅ Cosecha creada en #{harvest.fecha} - #{harvest.sector} - #{harvest.variety} - #{harvest.color}"
  else
    puts "❌ Error creando cosecha: #{harvest.errors.full_messages.join(', ')}"
  end
end

puts "Seed completado exitosamente 🎉"

puts "Seed completado exitosamente!"
