class ValidateAddForeignKeyUserToExpenses < ActiveRecord::Migration[8.0]
  def change
    validate_foreign_key :expenses, :users
  end
end
