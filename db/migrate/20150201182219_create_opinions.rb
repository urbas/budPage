class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      t.integer :user_id, null: false
      t.integer :response_id, null: false
      t.boolean :value, null: false
      t.timestamps null: false
    end

    add_foreign_key :opinions, :users, column: :user_id, on_delete: :cascade, on_update: :cascade
    add_foreign_key :opinions, :responses, column: :response_id, on_delete: :cascade, on_update: :cascade
    add_index :opinions, :user_id
    add_index :opinions, :response_id
  end
end
