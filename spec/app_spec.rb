require 'rspec'
require 'app'
require 'dotenv/load'
require 'json'

describe App do
    subject(:app) { App.new }
    let(:processed_books_array) {[
        { "title" => "Flowers", "authors" => ["Gail Saunders-Smith"], "publisher" => "Capstone"},
        { "title" => "On Flowers", "authors" => ["Amy Merrick"], "publisher" => "Artisan Books"},
        { "title" => "Bee's Flowers", "authors" => ["Corlet Dawn"], "publisher" => "Corlet Dawn"},
        { "title" => "Flowers", "authors" => ["Paul McEvoy"], "publisher" => "Blake Education"},
        { "title" => "Flowers in the Attic", "authors" => ["V.C. Andrews"], "publisher" => "Simon and Schuster"}
    ]}

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

        it "returns an array of books, each with title, authors, and publisher information" do
            expect(processed_books).to eq(processed_books_array)
        end
    end

    describe '#stdout' do
        let(:result) { app.stdout(processed_books, type) }

        context "with no processed books" do
            let(:processed_books) { [] }
            let(:type) { "Reading List" }

            it "outputs result to stdout" do 
                expect { result }.to output("Reading List is empty\n").to_stdout
            end
        end

        context "with one result" do
            let(:processed_books) { [{ "title" => "Flowers", "authors" => ["Gail Saunders-Smith"], "publisher" => "Capstone"}] }
            let(:type) { "Reading List" }

            it "outputs result to stdout" do
                expect { result }.to output("Reading List\n-----\n1\nTitle: Flowers\nAuthors: Gail Saunders-Smith\nPublisher: Capstone\n-----\n").to_stdout
            end
        end

        context "with five results" do
            let(:processed_books) { processed_books_array }
            let(:type) { "Search Result" }

            it "outputs result to stdout" do
                expect { result }.to output("Search Result\n-----\n1\nTitle: Flowers\nAuthors: Gail Saunders-Smith\nPublisher: Capstone\n-----\n2\nTitle: On Flowers\nAuthors: Amy Merrick\nPublisher: Artisan Books\n-----\n3\nTitle: Bee's Flowers\nAuthors: Corlet Dawn\nPublisher: Corlet Dawn\n-----\n4\nTitle: Flowers\nAuthors: Paul McEvoy\nPublisher: Blake Education\n-----\n5\nTitle: Flowers in the Attic\nAuthors: V.C. Andrews\nPublisher: Simon and Schuster\n-----\n").to_stdout
            end
        end
    end
end