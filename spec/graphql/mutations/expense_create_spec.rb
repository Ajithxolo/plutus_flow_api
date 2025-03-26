require 'rails_helper'

RSpec.describe 'ExpenseCreate Mutation', type: :request do
  describe 'creating an expense' do
    let(:mutation) do
      <<~GQL
        mutation($title: String!, $description: String, $amount: Float!, $date: ISO8601Date!) {
          expenseCreate(input: { title: $title, description: $description, amount: $amount, date: $date }) {
            expense {
              id
              title
              description
              amount
              date
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
        date: "2025-03-26"
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
          'date' => '2025-03-26'
        )
      end
    end
  end
end
