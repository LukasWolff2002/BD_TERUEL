class Sector < ApplicationRecord
  has_many :sector_varieties
  has_many :varieties, through: :sector_varieties
  
  validates :nombre, presence: true
  validates :descripcion, presence: true
end 