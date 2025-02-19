# Este archivo se encarga de crear los registros necesarios para que la aplicación funcione en
# cualquier entorno. Es idempotente en el sentido de que se pueden ejecutar varias veces para configurar la base.

puts "Reiniciando la base de datos..."

# Eliminamos registros sin disparar callbacks para evitar problemas con asociaciones incorrectas.
SectorVarietyColor.delete_all
VarietyColor.delete_all
Sector.delete_all
Reception.delete_all
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
User.create!([
  {
    nombre: "Lukas",
    apellido: "Wolff",
    rut: "21.030.696-k",
    email: "lwolff@miuandes.cl",
    cargo: "Administrativo",
    contrato: "interno"
  },
  {
    nombre: "Matias",
    apellido: "Devia",
    rut: "20.182.896-1",
    email: "pwolff012@gmail.com",
    cargo: "Administrativo",
    contrato: "interno"
  },
  {
    nombre: "Diego",
    apellido: "Ortiz",
    rut: "17.752.590-1",
    email: "carlos.sanchez@example.com",
    cargo: "Administrativo",
    contrato: "interno"
  }
])
