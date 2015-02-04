class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :user_id, :integer, null: false
      t.string :content, limit: 160, null: false
      t.integer :parent_id
      t.timestamps null: false
    end

    add_foreign_key :responses, :users, column: :user_id, on_delete: :nullify, on_update: :cascade
    add_foreign_key :responses, :responses, column: :parent_id, on_delete: :nullify, on_update: :cascade
    add_index :responses, :user_id
    add_index :responses, :parent_id
  end
end
