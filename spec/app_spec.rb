require 'rspec'
require 'app'
require 'dotenv/load'

describe App do

    subject(:app) { App.new }

    describe '#get_books' do
        let(:query) { "flowers" }
        let(:limit) { 5 }
        let(:api_key) { ENV["GOOGLE_BOOKS_KEY"] }
        let(:params) { { "q" => query, "maxResults" => limit, "key" => api_key } } 
        let(:books) { app.get_books(params) }

        it "returns a success code of 200" do
            expect(books.code).to eq(200)
        end

        it "returns five books" do 
            expect(books.body["items"].length).to eq(5)
        end

    end

end