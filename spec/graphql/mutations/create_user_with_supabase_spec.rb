require 'rails_helper'

RSpec.describe Mutations::CreateUserWithSupabase, type: :request do
  describe 'CreateUserWithSupabase Mutation' do
    let(:mutation) do
      <<~GQL
        mutation($token: String!) {
          createUserWithSupabase(token: $token) {
            user {
              id
              email
              name
              supabaseMetadata
            }
            errors
          }
        }
      GQL
    end

    let(:valid_token) do
      JWT.encode(
        {
          sub: "supabase_user_id",
          user_metadata: { email: "test@example.com", name: "Test User" }
        },
        SupabaseJwtHandler.secret_key,
        "HS256"
      )
    end

    context 'when the token is valid' do
      it 'creates a new user and returns the user details' do
        post '/graphql', params: { query: mutation, variables: { token: valid_token } }

        json = JSON.parse(response.body)
        data = json['data']['createUserWithSupabase']

        expect(data['user']).to include(
          'email' => 'test@example.com',
          'name' => 'Test User',
          'supabaseMetadata' => { 'email' => 'test@example.com', 'name' => 'Test User' }
        )
        expect(data['errors']).to be_empty

        user = User.find_by(supabase_id: "supabase_user_id")
        expect(user).not_to be_nil
        expect(user.email).to eq("test@example.com")
        expect(user.name).to eq("Test User")
        expect(user.supabase_metadata).to eq({ "email" => "test@example.com", "name" => "Test User" })
      end
    end
  end
end