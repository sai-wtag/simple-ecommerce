module V1
  module Resources
    class Items < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :items do
        desc "Return list of items"
        get do
          items = Item.all
          present items, with: V1::Entities::Item
        end
      end
    end
  end
end