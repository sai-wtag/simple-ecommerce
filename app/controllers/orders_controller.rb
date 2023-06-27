class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @items = Item.all.order(created_at: :desc)
    @order = Order.new
  end
end
