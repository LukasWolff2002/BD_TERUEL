class Fertilizer < ApplicationRecord
  has_many :fertilizer_histories, dependent: :destroy

  validates :nombre, presence: true
  validates :cantidad, numericality: { only_integer: true }
end 