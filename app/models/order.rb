class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items
  
  enum order_status: { pending: 0, shipped: 1, sent: 2, completed: 3, cancelled: -1 }
end
