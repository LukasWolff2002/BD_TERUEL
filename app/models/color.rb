class Color < ApplicationRecord
  has_many :variety_colors
  has_many :varieties, through: :variety_colors

  has_many :sector_variety_colors

  validates :nombre, presence: true, uniqueness: true

end