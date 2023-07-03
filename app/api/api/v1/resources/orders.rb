module V1
  module Resources
    class Orders < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      $user_id = 2

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

      desc "Return list of my orders"
      get 'my-orders' do
        orders = Order.where(user_id: $user_id).order(created_at: :desc)
        present orders, with: V1::Entities::Order
      end

      desc "Cancel an order"
      params do
        requires :id, type: Integer, desc: "Order id"
      end
      put 'cancel-order/:id' do
        order = Order.find(params[:id])

        if order.order_status != "pending" || order.user_id != $user_id
          error!('You are not allowed to cancel this order', 403)
        end

        order.update({
          order_status: "cancelled"
        })
        present order, with: V1::Entities::Order
      end
    end
  end
end