class Base < Grape::API
  format :json
  prefix :api
  version 'v1', :path

  mount V1::Resources::Items
  mount V1::Resources::Orders
end