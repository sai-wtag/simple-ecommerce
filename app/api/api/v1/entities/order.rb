module V1
  module Entities
    class Order < Grape::Entity
      expose :id, :total_price, :order_status
      expose :ordered_at
      expose :items, using: V1::Entities::OrderItem

      private
        def ordered_at
          object.created_at.strftime("%F %T")
        end

        def items
          object.order_items
        end
    end

  end
end