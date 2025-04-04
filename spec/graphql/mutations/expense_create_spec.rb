require 'rails_helper'

RSpec.describe 'ExpenseCreate Mutation', type: :request do
  describe 'creating an expense' do
    let(:user) { create(:user) }
    let(:mutation) do
      <<~GQL
        mutation($title: String!, $description: String, $amount: Float!, $date: ISO8601Date!, $userId: ID!) {
          expenseCreate(input: { title: $title, description: $description, amount: $amount, date: $date, userId: $userId }) {
            expense {
              id
              title
              description
              amount
              date
              user {
                id
                email
              }
            }
            errors
          }
        }
      GQL
    end

    let(:params) do
      {
        title: "Lunch",
        description: "Sandwich",
        amount: 15.50,
        date: "2025-03-26",
        userId: user.id
      }
    end
    context 'when the mutation is successful' do
      it 'creates a new expense' do
        post '/graphql', params: { query: mutation, variables: params.to_json }

        json = JSON.parse(response.body)
        data = json['data']['expenseCreate']['expense']

        expect(data).to include(
          'title' => 'Lunch',
          'description' => 'Sandwich',
          'amount' => 15.50,
          'date' => '2025-03-26',
          'user' => {
            'id' => user.id.to_s,
            'email' => user.email
          }
        )
      end
    end
    context 'when the mutation params is invalid' do
      it 'returns errors messages' do
        invalid_params = {
          title: "",
          description: "Sandwich",
          amount: 15.50,
          date: "2025-03-26",
          user_id: user.id
        }

        post '/graphql', params: { query: mutation, variables: invalid_params }

        json = JSON.parse(response.body)
        errors = json['errors']

        expect(errors).not_to be_empty
      end
    end
  end
end
