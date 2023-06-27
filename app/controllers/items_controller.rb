class ItemsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @items = Item.all.order(created_at: :desc)
  end

  def new
    @item = Item.new
  end

  def show
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:success] = "Item successfully created"
      redirect_to @item
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :price)
    end

end
