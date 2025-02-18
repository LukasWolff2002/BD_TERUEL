class Tool < ApplicationRecord
  has_many :tool_histories, dependent: :destroy

  validates :nombre, presence: true
  validates :cantidad, presence: true
end 