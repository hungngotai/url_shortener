require 'rails_helper'
require 'swagger_helper'

describe 'Url API' do
  path '/encoded' do
    post 'Generate url encoded' do
      tags 'Url'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          url: { type: :string }
        },
        required: %i[url]
      }

      response '201', 'Created' do
        let(:body) { { url: 'https://example.com' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['url']).to include(request.base_url)
          expect(data['url'].length).to eq(request.base_url.length + 8)
        end
      end

      response '400', 'Bad Request' do
        let(:body) { { url: 'invalid url' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to be_truthy
        end
      end
    end
  end

  path '/decoded' do
    post 'Generate url decoded' do
      tags 'Url'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          url: { type: :string }
        },
        required: %i[url]
      }

      response '200', 'Ok' do
        let!(:url) { create(:url) }
        let(:body) { { url: "http://www.example.com/#{url.shortened}" } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['url']).to eq(url.original_url)
        end
      end

      response '404', 'Not Found' do
        let(:body) { { url: 'https://not_found.com' } }

        run_test!
      end
    end
  end
end
