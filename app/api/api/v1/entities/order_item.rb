module V1
  module Entities
    class OrderItem < Grape::Entity
      expose :name
      expose :quantity
      expose :price

      private
        def name
          object.item.name
        end
    end
  end
end