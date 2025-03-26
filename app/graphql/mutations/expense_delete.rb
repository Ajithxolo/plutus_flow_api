# frozen_string_literal: true

module Mutations
  class ExpenseDelete < BaseMutation
    argument :id, ID, required: true

    field :message, String, null: true
    field :errors, [String], null: false

    def resolve(id:)
      expense = Expense.find_by(id: id)
      if expense&.destroy
        {
          message: "Expense deleted successfully",
          errors: []
        }
      else
        {
          message: nil,
          errors: ["Couldn't find Expense with 'id'=#{id}"]
        }
      end
    end
  end
end