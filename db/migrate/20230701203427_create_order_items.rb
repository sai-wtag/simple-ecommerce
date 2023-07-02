class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|

      t.references :order, null: false, foreign_key: true, on_delete: :cascade
      t.references :item, null: false, foreign_key: true
      t.integer :quantity, null: false
      
      t.timestamps
    end
  end
end
