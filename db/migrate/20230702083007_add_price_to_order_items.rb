class AddPriceToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :price, :decimal, after: :item_id, null: false, default: 0.0
  end
end
