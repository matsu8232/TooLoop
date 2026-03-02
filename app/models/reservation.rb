class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :item
  has_one :room
end
