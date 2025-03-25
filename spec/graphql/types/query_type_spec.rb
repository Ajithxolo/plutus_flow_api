require 'rails_helper'

RSpec.describe "Graphql query", type: :request do
  describe 'expenses query' do
    let!(:expense1) { create(:expense) }
    let!(:expense2) { create(:expense) }

    let(:query) do
      <<~GQL
        query {
          expenses {
            id
            title
            description
            amount
            date
          }
        }
      GQL
    end
    context 'when the query is successful' do
      it 'returns all expenses' do
        post '/graphql', params: { query: query }

        json = JSON.parse(response.body)
        data = json['data']['expenses']

        expect(data).to match_array([
          {
            'id' => expense1.id.to_s,
            'title' => expense1.title,
            'description' => expense1.description,
            'amount' => expense1.amount.to_f,
            'date' => expense1.date.to_s
          },
          {
            'id' => expense2.id.to_s,
            'title' => expense2.title,
            'description' => expense2.description,
            'amount' => expense2.amount.to_f,
            'date' => expense2.date.to_s
          }
        ])
      end
    end
  end
end
