module V1
  module Resources
    class Items < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      before do
        error!('401 Unauthorized', 401) unless @current_user.admin?
      end

      resource :items do
        desc "Return list of items"
        get do
          items = Item.all.order(created_at: :asc)
          present items, with: V1::Entities::Item
        end

        desc "Return a specific item"
        params do
          requires :id, type: Integer, desc: "Item id"
        end
        get ':id' do
          item = Item.find(params[:id])
          present item, with: V1::Entities::Item
        end

        desc "Create a new item"
        params do
          requires :name, type: String, desc: "Item name"
          requires :description, type: String, desc: "Item description"
          requires :price, type: Float, desc: "Item price"
          requires :available_quantity, type: Integer, desc: "Item available quantity"
        end
        post do
          item = Item.create!({
            name: params[:name],
            description: params[:description],
            price: params[:price],
            available_quantity: params[:available_quantity]
          })
          present item, with: V1::Entities::Item
        end

        desc "Update an existing item"
        params do
          requires :id, type: Integer, desc: "Item id"
          optional :name, type: String, desc: "Item name"
          optional :description, type: String, desc: "Item description"
          optional :price, type: Float, desc: "Item price"
          optional :available_quantity, type: Integer, desc: "Item available quantity"
        end
        put ':id' do
          item = Item.find(params[:id])
          item.update!({
            name: params[:name] || item.name,
            description: params[:description] || item.description,
            price: params[:price] || item.price,
            available_quantity: params[:available_quantity] || item.available_quantity
          })
          present item, with: V1::Entities::Item
        end

        desc "Delete an existing item"
        params do
          requires :id, type: Integer, desc: "Item id"
        end
        delete ':id' do
          item = Item.find(params[:id])
          item.destroy
          present item, with: V1::Entities::Item
        end
      end
    end
  end
end