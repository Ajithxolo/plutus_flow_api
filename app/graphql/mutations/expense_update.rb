# frozen_string_literal: true

module Mutations
  class ExpenseUpdate < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: true
    argument :description, String, required: false
    argument :amount, Float, required: true
    argument :date, GraphQL::Types::ISO8601Date, required: true

    field :expense, Types::ExpenseType, null: false
    field :errors, [ String ], null: false

    def resolve(id:, title:, description:, amount:, date:)
      expense = Expense.find(id)
      if expense.update(
        title: title,
        description: description,
        amount: amount,
        date: date
      )
        {
          expense: expense,
          errors: []
        }
      else
        {
          expense: nil,
          errors: expense.errors.full_messages
        }
      end
    end
  end
end
