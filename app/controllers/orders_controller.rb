class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if !current_user.admin?
      flash[:error] = "You are not authorized to view this page"
      redirect_to root_path
    end

    @orders = Order.all.order(created_at: :desc)
  end

  def new
    @items = Item.all.order(created_at: :desc)
    @order = Order.new
  end

  def create
    item_ids = params[:order][:item_ids]
    quantities = params[:order][:quantities]

    total_quantity = 0
    total_price = 0

    ordered_items = Hash.new(0)

    # Make a key value pair of item_id and quantity
    quantities.each_with_index do |quantity, index|
      if quantity.to_i > 0
        ordered_items[item_ids[index]] = quantity
      end

      total_quantity += quantity.to_i
    end

    if total_quantity == 0
      flash[:error] = "Please select at least one item"
      return redirect_to new_order_path
    end

    # Fetch all the ordered items from the database
    items = Item.where(id: ordered_items.keys)
    
    # Check if the ordered quantity is available in stock
    items.each do |item|
      if item.available_quantity < ordered_items[item.id.to_s].to_i
        flash[:error] = "Not enough #{item.name} in stock"
        return redirect_to new_order_path
      end

      total_price += item.price * ordered_items[item.id.to_s].to_i
    end

    order = Order.new(user_id: current_user.id, total_price: total_price)
    order.save

    ordered_items.each do |item_id, quantity|
      current_item = Item.find(item_id)
      OrderItem.create(order_id: order.id, item_id: item_id, quantity: quantity, price: current_item.price)

      # Update the available quantity of the item
      current_item.update(available_quantity: current_item.available_quantity - quantity.to_i)
    end

    flash[:success] = "Order created successfully"
    redirect_to root_path
  end

  def my_orders
    @orders = Order.where(user_id: current_user.id).order(created_at: :desc)
  end

  def cancel_order
    order = Order.find(params[:id])

    if !current_user.admin?  && order.user_id != current_user.id
      flash[:error] = "You are not authorized to view this page"
      return redirect_to root_path
    end

    order.update(order_status: "cancelled")

    order.order_items.each do |order_item|
      item = Item.find(order_item.item_id)
      item.update(available_quantity: item.available_quantity + order_item.quantity)
    end

    flash[:success] = "Order cancelled successfully"
    redirect_to my_orders_path
  end

  def change_order_status
    if !current_user.admin?
      flash[:error] = "You are not authorized to view this page"
      return redirect_to root_path
    end

    order = Order.find(params[:id])

    case order.order_status
    when "pending"
      order.update(order_status: "shipped")
    when "shipped"
      order.update(order_status: "delivered")
    end

    flash[:success] = "Order status updated successfully"
    redirect_to orders_path
  end

  def show
    order = Order.find(params[:id])

    if !current_user.admin?  && order.user_id != current_user.id
      flash[:error] = "You are not authorized to view this page"
      return redirect_to root_path
    end
    
    @order = order
  end

  def destroy
    if !current_user.admin?
      flash[:error] = "You are not authorized to view this page"
      redirect_to root_path
    end

    order = Order.find(params[:id])

    order.order_items.each do |order_item|
      item = Item.find(order_item.item_id)
      item.update(available_quantity: item.available_quantity + order_item.quantity)
    end

    order.destroy

    flash[:success] = "Order deleted successfully"
    redirect_to orders_path
  end
end
