class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category

  enum status: { available: 0, maintenance: 1 }
  
end
