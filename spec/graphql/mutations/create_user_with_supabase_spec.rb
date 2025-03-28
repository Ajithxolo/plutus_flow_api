require 'rails_helper'

RSpec.describe Mutations::CreateUserWithSupabase, type: :request do
  describe 'CreateUserWithSupabase Mutation' do
    let(:mutation) do
      <<~GQL
        mutation($token: String!) {
          createUserWithSupabase(input: {token: $token}) {
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
          user_metadata: { email: "test@example.com" }
        },
        SupabaseJwtHandler.secret_key,
        "HS256"
      )
    end

    let(:valid_params) do
      {
        token: valid_token
      }
    end

    context 'when the token is valid' do
      it 'creates a new user and returns the user details' do
        post '/graphql', params: { query: mutation, variables: valid_params.to_json }

        json = JSON.parse(response.body)
        data = json['data']['createUserWithSupabase']

        expect(data['user']).to include(
          'email' => 'test@example.com',
          'supabaseMetadata' => { 'email' => 'test@example.com' }
        )
        expect(data['errors']).to be_empty

        user = User.find_by(supabase_id: "supabase_user_id")
        expect(user).not_to be_nil
        expect(user.email).to eq("test@example.com")
        expect(user.name).to eq("")
        expect(user.supabase_metadata).to eq({ "email" => "test@example.com" })
      end
    end

    let(:invalid_token) { "invalid_token" }
    let(:invalid_params) do
      {
        token: invalid_token
     }
    end

    context 'when the token is invalid' do
      it 'returns an error message' do
        post '/graphql', params: { query: mutation, variables: invalid_params.to_json }

        json = JSON.parse(response.body)
        data = json['data']['createUserWithSupabase']

        expect(data['user']).to be_nil
        expect(data['errors']).to include("Invalid token: Not enough or too many segments")
      end
    end
  end
end