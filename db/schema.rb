# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_02_05_141549) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "SectorsVarieties", id: false, force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.bigint "variety_id", null: false
    t.index ["sector_id", "variety_id"], name: "index_SectorsVarieties_on_sector_id_and_variety_id", unique: true
    t.index ["sector_id"], name: "index_SectorsVarieties_on_sector_id"
    t.index ["variety_id"], name: "index_SectorsVarieties_on_variety_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agrochemical_divisions", force: :cascade do |t|
    t.string "division", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "agrochemical_histories", force: :cascade do |t|
    t.string "usuario", null: false, comment: "Nombre o identificador del usuario que realizó el cambio"
    t.bigint "agrochemical_id", null: false
    t.decimal "cantidad_cambiada", null: false, comment: "Cantidad agregada (valor positivo) o cantidad removida (valor negativo)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agrochemical_id"], name: "index_agrochemical_histories_on_agrochemical_id"
  end

  create_table "agrochemicals", force: :cascade do |t|
    t.string "nombre", null: false
    t.decimal "cantidad", null: false
    t.text "ingrediente_activo", null: false
    t.text "objetivo", null: false
    t.bigint "agrochemical_division_id", null: false
    t.integer "ph", null: false
    t.text "incomatibilidad", null: false
    t.text "carencias", null: false
    t.integer "reingreso", null: false
    t.text "daño_a_abejorros", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agrochemical_division_id"], name: "index_agrochemicals_on_agrochemical_division_id"
  end

  create_table "applications", force: :cascade do |t|
    t.date "fecha_aplicacion"
    t.date "fecha_de_liberacion"
    t.string "operador_tractor"
    t.string "aplicadores", default: [], array: true
    t.string "sector"
    t.float "hectareas"
    t.string "motivo"
    t.text "observaciones"
    t.string "maquinaria"
    t.string "agroquimicos", default: [], array: true
    t.float "dosis_en_100_l", default: [], array: true
    t.boolean "uso_de_proteccion", default: false
    t.boolean "lavado_de_equipo", default: false
    t.float "mojamiento_relativo"
    t.float "mojamiento_real"
    t.float "temperature"
    t.float "humidity"
    t.float "nubosidad"
    t.float "viento"
    t.datetime "hora_inicio"
    t.datetime "hora_fin"
    t.string "encargado_aplicacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colors", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_colors_on_nombre", unique: true
  end

  create_table "fertilizer_histories", force: :cascade do |t|
    t.string "usuario", null: false, comment: "Nombre o identificador del usuario que realizó el cambio"
    t.bigint "fertilizer_id", null: false
    t.integer "cantidad_cambiada", null: false, comment: "Cantidad agregada (valor positivo) o cantidad removida (valor negativo)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fertilizer_id"], name: "index_fertilizer_histories_on_fertilizer_id"
  end

  create_table "fertilizers", force: :cascade do |t|
    t.string "nombre", null: false
    t.integer "cantidad", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "harvests", force: :cascade do |t|
    t.date "fecha"
    t.time "hora"
    t.string "user"
    t.string "sector"
    t.string "variety"
    t.string "color"
    t.string "volante_nombre"
    t.string "cosechero_nombre"
    t.integer "cajas", default: 0, null: false
    t.decimal "kilos_por_caja", precision: 5, scale: 2
    t.string "calidad"
    t.decimal "kilos_tomates", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fecha"], name: "index_harvests_on_fecha"
  end

  create_table "images", force: :cascade do |t|
    t.bigint "reception_id", null: false
    t.binary "image"
    t.string "filename", null: false
    t.string "content_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reception_id"], name: "index_images_on_reception_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.integer "cantidad", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "irrigations", force: :cascade do |t|
    t.date "fecha"
    t.time "hora"
    t.bigint "user_id", null: false
    t.bigint "sector_id"
    t.integer "nro_pulsos"
    t.decimal "tiempo_pulso", precision: 5, scale: 2
    t.decimal "riego_entrada_mm", precision: 5, scale: 2
    t.decimal "riego_entrada_ph", precision: 4, scale: 2
    t.decimal "riego_entrada_ce", precision: 5, scale: 2
    t.decimal "riego_entrada_nitratos", precision: 6, scale: 2
    t.decimal "riego_entrada_potasio", precision: 6, scale: 2
    t.decimal "drenaje_riego_mm", precision: 5, scale: 2
    t.decimal "drenaje_riego_ph", precision: 4, scale: 2
    t.decimal "drenaje_riego_ce", precision: 5, scale: 2
    t.decimal "drenaje_riego_nitratos", precision: 6, scale: 2
    t.decimal "drenaje_riego_potasio", precision: 6, scale: 2
    t.decimal "humedad_inicial", precision: 5, scale: 2
    t.decimal "ce_inicial", precision: 5, scale: 2
    t.decimal "humedad_final", precision: 5, scale: 2
    t.decimal "ce_final", precision: 5, scale: 2
    t.integer "pulsos_agua"
    t.decimal "tiempo_pulsos_agua", precision: 5, scale: 2
    t.decimal "potasio_hoja", precision: 6, scale: 2
    t.decimal "nitratos_hoja", precision: 6, scale: 2
    t.decimal "porcentaje_drenaje", precision: 5, scale: 2
    t.integer "muestras"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sector_id"], name: "index_irrigations_on_sector_id"
    t.index ["user_id"], name: "index_irrigations_on_user_id"
  end

  create_table "receptions", force: :cascade do |t|
    t.date "fecha", null: false
    t.time "hora", null: false
    t.string "nro_guia_despacho", null: false
    t.decimal "kilos_totales", precision: 10, scale: 2, default: "0.0", null: false
    t.jsonb "reception_items", default: [], null: false
    t.integer "supplier_id"
    t.string "supplier_nombre"
    t.string "supplier_rut"
    t.integer "user_id"
    t.boolean "activo", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_receptions_on_supplier_id"
  end

  create_table "sector_varieties", id: false, force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.bigint "variety_id", null: false
    t.index ["sector_id", "variety_id"], name: "index_sector_varieties_on_sector_id_and_variety_id", unique: true
    t.index ["sector_id"], name: "index_sector_varieties_on_sector_id"
    t.index ["variety_id"], name: "index_sector_varieties_on_variety_id"
  end

  create_table "sector_variety_colors", force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.bigint "variety_id", null: false
    t.bigint "color_id", null: false
    t.index ["color_id"], name: "index_sector_variety_colors_on_color_id"
    t.index ["sector_id", "variety_id", "color_id"], name: "index_sector_variety_colors_on_all", unique: true
    t.index ["sector_id"], name: "index_sector_variety_colors_on_sector_id"
    t.index ["variety_id"], name: "index_sector_variety_colors_on_variety_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "nombre"
    t.integer "hectareas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_sectors_on_nombre", unique: true
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "nombre"
    t.string "rut"
  end

  create_table "tool_histories", force: :cascade do |t|
    t.string "usuario", null: false, comment: "Nombre o identificador del usuario que realizó el cambio"
    t.bigint "tool_id", null: false
    t.integer "cantidad_cambiada", null: false, comment: "Cantidad agregada (valor positivo) o cantidad removida (valor negativo)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tool_id"], name: "index_tool_histories_on_tool_id"
  end

  create_table "tools", force: :cascade do |t|
    t.string "nombre", null: false
    t.integer "cantidad", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "nombre"
    t.string "apellido"
    t.string "rut"
    t.string "email"
    t.string "cargo"
    t.string "contrato"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cargo"], name: "index_users_on_cargo"
    t.index ["rut"], name: "index_users_on_rut"
  end

  create_table "varieties", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_varieties_on_nombre", unique: true
  end

  create_table "variety_colors", id: false, force: :cascade do |t|
    t.bigint "variety_id", null: false
    t.bigint "color_id", null: false
    t.index ["color_id"], name: "index_variety_colors_on_color_id"
    t.index ["variety_id", "color_id"], name: "index_variety_colors_on_variety_id_and_color_id", unique: true
    t.index ["variety_id"], name: "index_variety_colors_on_variety_id"
  end

  add_foreign_key "SectorsVarieties", "sectors"
  add_foreign_key "SectorsVarieties", "varieties"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agrochemical_histories", "agrochemicals"
  add_foreign_key "agrochemicals", "agrochemical_divisions"
  add_foreign_key "fertilizer_histories", "fertilizers"
  add_foreign_key "images", "receptions"
  add_foreign_key "irrigations", "sectors"
  add_foreign_key "irrigations", "users"
  add_foreign_key "sector_varieties", "sectors"
  add_foreign_key "sector_varieties", "varieties"
  add_foreign_key "sector_variety_colors", "colors"
  add_foreign_key "sector_variety_colors", "sectors"
  add_foreign_key "sector_variety_colors", "varieties"
  add_foreign_key "tool_histories", "tools"
  add_foreign_key "variety_colors", "colors"
  add_foreign_key "variety_colors", "varieties"
end
