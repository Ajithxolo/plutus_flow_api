class AddUserReferenceToExpenses < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!
  def change
    add_reference :expenses, :user, null: false, index: {algorithm: :concurrently}
  end
end
