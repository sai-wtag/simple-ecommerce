class Item < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  validates :name, :description, :price, presence: true
  validates :name, length: { minimum: 3, maximum: 50 }
  validates :price, numericality: { greater_than: 0 }
end
