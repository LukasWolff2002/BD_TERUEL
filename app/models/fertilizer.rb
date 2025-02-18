class Fertilizer < ApplicationRecord
  has_many :fertilizer_histories, dependent: :destroy

  validates :nombre, presence: true
  validates :cantidad, presence: true
end 