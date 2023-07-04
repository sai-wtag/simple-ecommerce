# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# if there is no OAuth application created, create them
if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create(name: "iOS", redirect_uri: "", scopes: "")
  Doorkeeper::Application.create(name: "Android", redirect_uri: "", scopes: "")
  Doorkeeper::Application.create(name: "Vue", redirect_uri: "", scopes: "")
end