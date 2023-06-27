class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false, unique: true
      t.text :description, null: false, unique: true
      t.decimal :price, null: false, unique: true
      t.integer :available_quantity, default: 0

      t.timestamps
    end
  end
end
