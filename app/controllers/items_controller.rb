class ItemsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @items = Item.all.order(created_at: :desc)
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
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
  
  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
      if @item.update(item_params)
        flash[:success] = "Item was successfully updated"
        redirect_to @item
      else
        flash[:error] = "Something went wrong"
        render :edit, status: :unprocessable_entity
      end
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :price)
    end

end
