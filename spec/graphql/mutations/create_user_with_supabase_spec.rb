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

    let(:valid_token) { "valid_token" }
    let(:invalid_token) { "invalid_token" }

    let(:decoded_payload) do
      SupabaseJwtHandler::DecodedTokenPayload.new(
        {
          "sub" => "supabase_user_id",
          "user_metadata" => { "email" => "test@example.com", "name" => "" }
        }
      )
    end

    before do
      # Stub for valid token
      allow(SupabaseJwtHandler).to receive(:decode_token!).with(valid_token).and_return(decoded_payload)

      # Stub for invalid token
      allow(SupabaseJwtHandler).to receive(:decode_token!).with(invalid_token).and_raise(JWT::DecodeError, "Invalid token: Not enough or too many segments")
    end

    let(:valid_params) do
      {
        token: valid_token
      }
    end

    let(:invalid_params) do
      {
        token: invalid_token
      }
    end

    context 'when the token is valid' do
      it 'creates a new user and returns the user details' do
        post '/graphql', params: { query: mutation, variables: valid_params.to_json }

        json = JSON.parse(response.body)
        data = json['data']['createUserWithSupabase']

        expect(data['user']).to include(
          'email' => 'test@example.com',
          'supabaseMetadata' => { 'email' => 'test@example.com', 'name' => '' }
        )
        expect(data['errors']).to be_empty

        user = User.find_by(supabase_id: "supabase_user_id")
        expect(user).not_to be_nil
        expect(user.email).to eq("test@example.com")
        expect(user.supabase_metadata).to eq({ "email" => "test@example.com", "name" => "" })
      end
    end

    context 'when the token is invalid' do
      it 'returns an error message' do
        post '/graphql', params: { query: mutation, variables: invalid_params.to_json }

        json = JSON.parse(response.body)
        data = json['data']['createUserWithSupabase']

        expect(data['user']).to be_nil
        expect(data['errors'][0]).to include("Invalid token: Not enough or too many segments")
      end
    end

    context 'when the user cannot be saved' do
      before do
        allow(User).to receive(:find_or_initialize_by).and_return(User.new)
        allow_any_instance_of(User).to receive(:save).and_return(false)
        allow_any_instance_of(User).to receive_message_chain(:errors, :full_messages).and_return(["Email can't be blank"])
      end

      it 'returns validation errors' do
        post '/graphql', params: { query: mutation, variables: valid_params.to_json }

        json = JSON.parse(response.body)
        data = json['data']['createUserWithSupabase']

        expect(data['user']).to be_nil
        expect(data['errors']).to include("Email can't be blank")
      end
    end
  end
end
