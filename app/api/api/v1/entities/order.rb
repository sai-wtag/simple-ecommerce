module V1
  module Entities
    class Order < Grape::Entity
      expose :id, :total_price, :order_status
      expose :ordered_at

      private
        def ordered_at
          object.created_at.strftime("%F %T")
        end
    end

  end
end