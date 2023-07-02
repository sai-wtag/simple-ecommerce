class Base < Grape::API
    mount V1::Resources::Items
end