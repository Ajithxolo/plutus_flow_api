class AddForeignKeyUserToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :expenses, :users, column: :user_id, null: false, index: {algorithm: :concurrently}, validate: false
  end
end
