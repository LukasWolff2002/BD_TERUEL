class AgrochemicalDivision < ApplicationRecord
  has_many :agrochemicals, dependent: :restrict_with_exception

  validates :division, presence: true
end 