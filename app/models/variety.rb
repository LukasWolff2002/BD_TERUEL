class Variety < ApplicationRecord
  has_many :sector_varieties
  has_many :sectors, through: :sector_varieties
  has_many :receptions

  validates :nombre, presence: true
  validates :color, presence: true

  def to_s
    nombre
  end
end 