# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :expenses, [ ExpenseType ], null: false

    def expenses
      Expense.all
    end
  end
end
