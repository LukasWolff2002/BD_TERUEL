class Variety < ApplicationRecord
  has_and_belongs_to_many :sectors, join_table: 'SectorsVarieties'
  has_many :receptions

  validates :nombre, presence: true
  validates :color, presence: true

  def to_s
    nombre
  end
end 