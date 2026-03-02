class Room < ApplicationRecord
  belongs_to :reservation

  has_many :entries, dependent: :destroy
  has_many :chat, dependent: :destroy
end
