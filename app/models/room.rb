class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :chat, dependent: :destroy
  has_many :users, through: :entries
end
