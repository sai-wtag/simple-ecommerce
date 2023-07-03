module V1
  module Resources
    class Orders < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      $user_id = 1
      $user = User.find($user_id)

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

        desc "Delete an existing order"
        params do
          requires :id, type: Integer, desc: "Order id"
        end
        delete ':id' do
          if $user.role != "admin"
            error!('You are not allowed to change this order status', 403)
          end

          order = Order.find(params[:id])
          order.destroy

          present order, with: V1::Entities::Order, nested_attributes: false
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

      desc "Change order status"
      params do
        requires :id, type: Integer, desc: "Order id"
      end
      put 'change-order-status/:id' do
        order = Order.find(params[:id])

        print $user.role

        if $user.role != "admin" || ["delivered", "cancelled"].include?(order.order_status)
          error!('You are not allowed to change this order status', 403)
        end

        case order.order_status
        when "pending"
          new_status = "shipped"
        when "shipped"
          new_status = "delivered"
        end          

        order.update({
          order_status: new_status
        })
        present order, with: V1::Entities::Order
      end

      
    end
  end
end