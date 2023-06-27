class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @items = Item.all.order(created_at: :desc)
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      @order.update(user_id: current_user.id)
      flash[:success] = "Order successfully created"
      redirect_to @order
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end
end
