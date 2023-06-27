class Item < ApplicationRecord
  validates :name, :description, :price, presence:true

  validates :name, length: { minimum: 3, maximum: 50 }
  validates :price, numericality: { greater_than: 0 }
end
