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
          if $user.role != "admin"
            error!('You are not allowed to view this page', 403)
          end

          orders = Order.all.order(created_at: :desc)
          present orders, with: V1::Entities::Order
        end

        desc "Return a specific order"
        params do
          requires :id, type: Integer, desc: "Order id"
        end
        get ':id' do
          order = Order.find(params[:id])

          if $user.role != "admin" && order.user_id != $user_id
            error!('You are not allowed to view this page', 403)
          end
          
          present order, with: V1::Entities::Order
        end

        desc "Create a new order"
        params do
          requires :order_items, type: Array
        end
        post do
          if $user.role == "admin"
            error!('Your are an admin, so you are not allowed to create an order', 403)
          end

          total_quantity = 0
          total_price = 0

          params[:order_items].each do |order_item|
            item = Item.find(order_item[:item_id])
            quantity = order_item[:quantity].to_i

            total_quantity += quantity
            total_price += item.price * quantity

            if quantity > item.available_quantity
              error!("Not enough #{item.name} in stock", 403)
            end
          end
      
          if total_quantity == 0
            error!("Please select at least one item", 403)
          end

          order = Order.create({
            user_id: $user_id,
            order_status: "pending",
            total_price: total_price
          })

          params[:order_items].each do |order_item|
            item = Item.find(order_item[:item_id])
            OrderItem.create({
              order_id: order.id,
              item_id: order_item[:item_id],
              quantity: order_item[:quantity],
              price: item.price
            })

            # Update the available quantity of the item
            item.update({
              available_quantity: item.available_quantity - order_item[:quantity]
            })
          end

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

          if order.order_status != "cancelled"
            # Update the available quantity of the item
            order.order_items.each do |order_item|
              item = Item.find(order_item.item_id)
              item.update({
                available_quantity: item.available_quantity + order_item.quantity
              })
            end
          end

          order.destroy
          present order, with: V1::Entities::Order
        end
      end

      desc "Return list of my orders"
      get 'my-orders' do
        if $user.role == "admin"
          error!('You are not allowed to view this page', 403)
        end

        orders = Order.where(user_id: $user_id).order(created_at: :desc)
        present orders, with: V1::Entities::Order
      end

      desc "Cancel an order"
      params do
        requires :id, type: Integer, desc: "Order id"
      end
      put 'cancel-order/:id' do
        order = Order.find(params[:id])

        if order.user_id != $user_id
          error!('You are not allowed to cancel this order', 403)
        end

        if order.order_status != "pending"
          error!("This order has already been #{order.order_status}, so you can not cancel this order", 403)
        end

        order.update({
          order_status: "cancelled"
        })

        # Update the available quantity of the item
        order.order_items.each do |order_item|
          item = Item.find(order_item.item_id)
          item.update({
            available_quantity: item.available_quantity + order_item.quantity
          })
        end

        present order, with: V1::Entities::Order
      end

      desc "Change order status"
      params do
        requires :id, type: Integer, desc: "Order id"
      end
      put 'change-order-status/:id' do
        order = Order.find(params[:id])

        if $user.role == "admin"
          error!('You are an admin, so you are not allowed to change this order status', 403)
        end

        if ["delivered", "cancelled"].include?(order.order_status)
          error!("This order has already been #{order.order_status}", 403)
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