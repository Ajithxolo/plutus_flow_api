require 'rails_helper'

RSpec.describe 'ExpenseDelete Mutation', type: :request do
  describe 'deleting an expense' do
    let(:expense) { create(:expense) }

    let(:mutation) do
      <<~GQL
        mutation($id: ID!) {
          expenseDelete(input: {id: $id}) {
            message
            errors
          }
        }
      GQL
    end

    let(:params) do
      {
        id: expense.id
      }
    end

    context 'when the mutation is successful' do
      it 'deletes an expense and returns a success message' do
        post '/graphql', params: { query: mutation, variables: params.to_json }

        json = JSON.parse(response.body)
        data = json['data']['expenseDelete']

        expect(data).to include(
          'message' => 'Expense deleted successfully',
          'errors' => []
        )
      end
    end
    context 'when the mutation params are invalid' do
      it 'returns error messages' do
        invalid_params =   {
          id: 0
        }

        post '/graphql', params: { query: mutation, variables: invalid_params.to_json }

        json = JSON.parse(response.body)
        errors = json['data']['expenseDelete']['errors']

        expect(errors).to include("Couldn't find Expense with 'id'=0")
      end
    end
  end
end
