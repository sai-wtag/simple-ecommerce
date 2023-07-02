module V1
  module Entities
    class Item < Grape::Entity
      expose :id, :name, :description, :price
    end
  end
end