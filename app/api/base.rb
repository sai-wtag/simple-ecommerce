require 'doorkeeper/grape/helpers'

class Base < Grape::API
  helpers Doorkeeper::Grape::Helpers

  format :json
  prefix :api
  version 'v1', :path

  before do
    doorkeeper_authorize!
  end

  before do
    @current_user ||= User.find(doorkeeper_token[:resource_owner_id])
  end

  mount V1::Resources::Items
  mount V1::Resources::Orders
end