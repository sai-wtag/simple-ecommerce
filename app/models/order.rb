class Order < ApplicationRecord
  enum order_status: { pending: 0, completed: 1, cancelled: -1 }
end
