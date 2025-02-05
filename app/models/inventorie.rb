class Inventorie < ApplicationRecord
  has_many :inventorie_histories, dependent: :destroy
end 