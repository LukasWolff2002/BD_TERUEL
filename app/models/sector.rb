class Sector < ApplicationRecord
  has_and_belongs_to_many :varieties, join_table: 'SectorsVarieties'
  accepts_nested_attributes_for :varieties, allow_destroy: true
  
  validates :nombre, presence: true
  validates :descripcion, presence: true
end 