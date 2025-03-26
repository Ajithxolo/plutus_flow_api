# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :expense_create, mutation: Mutations::ExpenseCreate
  end
end
