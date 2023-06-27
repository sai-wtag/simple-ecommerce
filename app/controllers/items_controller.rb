class ItemsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @items = Item.all.order(created_at: :desc)
  end

end
