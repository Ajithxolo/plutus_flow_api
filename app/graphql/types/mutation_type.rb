# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :expense_create, mutation: Mutations::ExpenseCreate
    field :expense_update, mutation: Mutations::ExpenseUpdate
    field :expense_delete, mutation: Mutations::ExpenseDelete
  end
end
