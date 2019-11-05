require "rspec"
require "search"
require "dotenv/load"

describe Search do
  subject(:search) { Search.new(limit, query) }
  let(:limit) { 5 }

  describe "#get_books" do
    let(:params) { { "q" => query, "maxResults" => limit, "key" =>  ENV["GOOGLE_BOOKS_KEY"] } }
    let(:books) { search.get_books(params) }

    context "with a good request" do
      let(:query) { "flowers" }

      it "returns a success code of 200" do
        expect(books.code).to eq(200)
      end 
    end

    context "with a bad request" do
      let(:query) { "" }

      it "returns false" do
        expect(books).to eq(false)
      end 
    end
  end

  describe "#process_books" do
    let(:query) { "flowers" }
    let(:processed_books) { search.process_books(data) }

    context "with a value of false" do
      let(:data) { false }

      it "returns a value of false" do
        expect(processed_books).to eq(false)
      end
    end

    context "with no books" do
      let(:data) { File.read('spec/data_2.txt') }

      it "returns an empty array" do
        expect(processed_books).to eq([])
      end
    end

    context "with one book and some information blank" do
      let(:data) { File.read('spec/data_3.txt') }

      it "returns an array of one book with title, author, and publisher information" do
        expect(processed_books).to eq([
          { "title" => "Flowers", "authors" => nil, "publisher" => "Capstone" }
        ])
      end
    end

    context "with five books and some information blank" do
      let(:data) { File.read('spec/data.txt') }
      let(:processed_books_array) {[
        { "title" => "Flowers", "authors" => nil, "publisher" => "Capstone" },
        { "title" => "On Flowers", "authors" => ["Amy Merrick"], "publisher" => nil },
        { "title" => "Bee's Flowers", "authors" => ["Corlet Dawn"], "publisher" => "Corlet Dawn" },
        { "title" => "Flowers", "authors" => ["Paul McEvoy"], "publisher" => "Blake Education" },
        { "title" => "Flowers in the Attic", "authors" => ["V.C. Andrews"], "publisher" => "Simon and Schuster" }
      ]}

      it "returns an array of five books, each with title, authors, and publisher information" do
        expect(processed_books).to eq(processed_books_array)
      end
    end
  end
  
  describe "#search_results" do

    context "with search results" do
      let(:query) { "1.3333333333333333333" }

      it "returns an array of results with each book's title, author, and publisher information" do
        expect(search.search_results).to eq([
          { "title" => "Return of the Old Ones", "authors" => ["Brian Sammons"], "publisher" => nil }
        ])
      end
    end

    context "with no search results" do
      let(:query) { "tokillamockingbird40th" }

      it "returns an empty array" do
        expect(search.search_results).to eq([])
      end
    end

    context "with a search error" do
      let(:query) { "1.3333333333333333333" }
      
      it "returns a value of false" do
        api_key_orig = ENV["GOOGLE_BOOKS_KEY"]
        ENV["GOOGLE_BOOKS_KEY"] = "hello"
        expect(search.search_results).to eq(false)
        ENV["GOOGLE_BOOKS_KEY"] = api_key_orig
      end
    end
  end
end