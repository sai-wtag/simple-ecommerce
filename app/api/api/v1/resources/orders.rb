module V1
  module Resources
    class Orders < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :orders do
        desc "Return list of orders"
        get do
          orders = Order.all.order(created_at: :desc)
          present orders, with: V1::Entities::Order
        end

        desc "Return a specific order"
        params do
          requires :id, type: Integer, desc: "Order id"
        end
        get ':id' do
          order = Order.find(params[:id])
          present order, with: V1::Entities::Order
        end
      end
    end
  end
end