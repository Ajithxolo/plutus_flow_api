module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :name, String, null: true
    field :supabase_metadata, GraphQL::Types::JSON, null: true
  end
end