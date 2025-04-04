# frozen_string_literal: true

module Mutations
  class ExpenseCreate < BaseMutation
    argument :title, String, required: true
    argument :description, String, required: false
    argument :amount, Float, required: true
    argument :date, GraphQL::Types::ISO8601Date, required: true
    argument :userId, ID, required: true

    field :expense, Types::ExpenseType, null: false
    field :errors, [ String ], null: false

    def resolve(title:, description:, amount:, date:, userId:)
      expense = Expense.new(
        title: title,
        description: description,
        amount: amount,
        date: date,
        user_id: userId
      )
      if expense.save
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
