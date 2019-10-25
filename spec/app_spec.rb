require 'rspec'
require 'app'
require 'dotenv/load'
require 'rest-client'
require 'json'

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
            expect(JSON.parse(books)["items"].length).to eq(5)
        end

    end

    describe '#process_books' do

        let(:data) { File.read('spec/data.txt') }
        let(:processed_books) { app.process_books(data) }
        let(:processed_books_array) {[
            { "title" => "Flowers", "authors" => ["Gail Saunders-Smith"], "publisher" => "Capstone"},
            { "title" => "On Flowers", "authors" => ["Amy Merrick"], "publisher" => "Artisan Books"},
            { "title" => "Bee's Flowers", "authors" => ["Corlet Dawn"], "publisher" => "Corlet Dawn"},
            { "title" => "Flowers", "authors" => ["Paul McEvoy"], "publisher" => "Blake Education"},
            { "title" => "Flowers in the Attic", "authors" => ["V.C. Andrews"], "publisher" => "Simon and Schuster"}
        ]}

        it "returns an array of books, each with title, authors, and publisher information" do
            expect(processed_books).to eq(processed_books_array)
        end

    end

end