class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @items = Item.all.order(created_at: :desc)
    @order = Order.new
  end

  def create
    item_ids = params[:order][:item_ids]
    quantities = params[:order][:quantities]

    ordered_items = Hash.new(0)

    # Make a key value pair of item_id and quantity
    quantities.each_with_index do |quantity, index|
      if quantity.to_i > 0
        ordered_items[item_ids[index]] = quantity
      end
    end

    # Fetch all the ordered items from the database
    items = Item.where(id: ordered_items.keys)
    total_price = 0
    
    # Check if the ordered quantity is available in stock
    items.each do |item|
      if item.available_quantity < ordered_items[item.id.to_s].to_i
        flash[:error] = "Not enough #{item.name} in stock"
        redirect_to new_order_path

        return
      end

      total_price += item.price * ordered_items[item.id.to_s].to_i
    end

    order = Order.new(user_id: current_user.id, total_price: total_price)
    order.save

    ordered_items.each do |item_id, quantity|
      OrderItem.create(order_id: order.id, item_id: item_id, quantity: quantity)

      # Update the available quantity of the item
      current_item = Item.find(item_id)
      current_item.update(available_quantity: current_item.available_quantity - quantity.to_i)
    end

    flash[:success] = "Order created successfully"
    redirect_to root_path
  end

  def my_orders
    @orders = Order.where(user_id: current_user.id).order(created_at: :asc)
  end
end
