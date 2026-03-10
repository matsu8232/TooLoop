class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_many :items, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :chats
  has_many :rooms, through: :entries

  has_many :rented_items, through: :reservations, source: :item

  validates :name, presence: true
end
