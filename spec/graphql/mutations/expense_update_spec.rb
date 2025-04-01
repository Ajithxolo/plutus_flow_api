require 'rails_helper'

RSpec.describe 'ExpenseUpdate Mutation', type: :request do
  describe 'updating an expense' do
    let(:expense) { create(:expense) }

    let(:mutation) do
      <<~GQL
        mutation($id: ID!, $title: String!, $description: String, $amount: Float!, $date: ISO8601Date!) {
          expenseUpdate(input: { id: $id, title: $title, description: $description, amount: $amount, date: $date }) {
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
        id: expense.id,
        title: "Dinner",
        description: "Pizza",
        amount: 20.50,
        date: "2025-03-26"
      }
    end

    context 'when the mutation is successful' do
      it 'updates an expense' do
        post '/graphql', params: { query: mutation, variables: params.to_json }

        json = JSON.parse(response.body)
        data = json['data']['expenseUpdate']['expense']

        expect(data).to include(
          'title' => 'Dinner',
          'description' => 'Pizza',
          'amount' => 20.50,
          'date' => '2025-03-26'
        )
      end
    end

    context 'when the mutation params is invalid' do
      it 'returns errors messages' do
        invalid_params = {
          id: expense.id,
          title: "",
          description: "Pizza",
          amount: 20.50,
          date: "2025-03-26"
        }

        post '/graphql', params: { query: mutation, variables: invalid_params }

        json = JSON.parse(response.body)
        errors = json['errors']

        expect(errors).not_to be_empty
      end
    end
  end
end
