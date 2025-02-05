class SectorVariety < ApplicationRecord
  belongs_to :sector
  belongs_to :variety

  validates :sector_id, uniqueness: { scope: :variety_id }
end 