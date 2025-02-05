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

ActiveRecord::Schema[7.1].define(version: 2025_02_03_180257) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "harvests", force: :cascade do |t|
    t.date "fecha"
    t.time "hora"
    t.string "sector"
    t.string "variedad"
    t.string "volante_rut"
    t.string "volante_nombre"
    t.string "encargado_cosecha"
    t.string "cosechero_rut"
    t.string "cosechero_nombre"
    t.integer "cajas"
    t.decimal "kilos_por_caja", precision: 5, scale: 2
    t.string "calidad"
    t.decimal "kilos_tomates", precision: 8, scale: 2
    t.string "evaluador"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cosechero_rut"], name: "index_harvests_on_cosechero_rut"
    t.index ["fecha"], name: "index_harvests_on_fecha"
    t.index ["sector"], name: "index_harvests_on_sector"
    t.index ["volante_rut"], name: "index_harvests_on_volante_rut"
  end

  create_table "images", force: :cascade do |t|
    t.bigint "reception_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reception_id"], name: "index_images_on_reception_id"
  end

  create_table "irrigations", force: :cascade do |t|
    t.date "fecha"
    t.time "hora"
    t.bigint "encargado_de_riego_id"
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
    t.index ["encargado_de_riego_id"], name: "index_irrigations_on_encargado_de_riego_id"
    t.index ["sector_id"], name: "index_irrigations_on_sector_id"
  end

  create_table "receptions", force: :cascade do |t|
    t.date "fecha", null: false
    t.time "hora", null: false
    t.bigint "sector_id", null: false
    t.bigint "variety_id", null: false
    t.bigint "user_id", null: false
    t.string "color"
    t.string "nro_guia_despacho"
    t.string "firmeza"
    t.string "calidad"
    t.integer "pallets"
    t.integer "cajas"
    t.decimal "kilos_cajas", precision: 5, scale: 2
    t.decimal "kilos_totales", precision: 10, scale: 2
    t.boolean "activo", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sector_id"], name: "index_receptions_on_sector_id"
    t.index ["user_id"], name: "index_receptions_on_user_id"
    t.index ["variety_id"], name: "index_receptions_on_variety_id"
  end

  create_table "sector_varieties", force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.bigint "variety_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sector_id", "variety_id"], name: "index_sector_varieties_on_sector_id_and_variety_id", unique: true
    t.index ["sector_id"], name: "index_sector_varieties_on_sector_id"
    t.index ["variety_id"], name: "index_sector_varieties_on_variety_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_sectors_on_nombre", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "nombre"
    t.string "apellido"
    t.string "rut"
    t.string "cargo"
    t.string "contrato"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cargo"], name: "index_users_on_cargo"
    t.index ["rut"], name: "index_users_on_rut"
  end

  create_table "varieties", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_varieties_on_nombre", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "images", "receptions"
  add_foreign_key "irrigations", "sectors"
  add_foreign_key "irrigations", "users", column: "encargado_de_riego_id"
  add_foreign_key "receptions", "sectors"
  add_foreign_key "receptions", "users"
  add_foreign_key "receptions", "varieties"
  add_foreign_key "sector_varieties", "sectors"
  add_foreign_key "sector_varieties", "varieties"
end
