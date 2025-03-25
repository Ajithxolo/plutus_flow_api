module Types
  class ExpenseType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: false
    field :amount, Float, null: false
    field :date, GraphQL::Types::ISO8601Date, null: false
  end
end