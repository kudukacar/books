require "rspec"
require "app"
require "user"
require "dotenv/load"
require "stringio"

describe App do
  subject(:app) { App.new(5) }
  let(:limit) { app.limit }
  let(:api_key) { ENV["GOOGLE_BOOKS_KEY"] }
  let(:processed_books_array) {[
    { "title" => "Flowers", "authors" => nil, "publisher" => "Capstone" },
    { "title" => "On Flowers", "authors" => ["Amy Merrick"], "publisher" => nil },
    { "title" => "Bee's Flowers", "authors" => ["Corlet Dawn"], "publisher" => "Corlet Dawn" },
    { "title" => "Flowers", "authors" => ["Paul McEvoy"], "publisher" => "Blake Education" },
    { "title" => "Flowers in the Attic", "authors" => ["V.C. Andrews"], "publisher" => "Simon and Schuster" }
  ]}

  describe "#initialize" do
    it "records the search results to display" do
      expect(app.limit).to eq(5)
    end

    it "sets up a user do" do
      expect(app.user).to be_an_instance_of(User)
    end
  end

  describe "#search_params" do
    after(:each) do
      $stdin = STDIN
    end

    it "returns a hash of search params" do
      $stdin = StringIO.new("flowers\n")
      expect(app.search_params).to eq({ "q" => "flowers", "maxResults" => limit, "key" => api_key })
    end
  end

  describe "#get_books" do
    let(:params) { { "q" => query, "maxResults" => limit, "key" => api_key } }
    let(:books) { app.get_books(params) }

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
    let(:processed_books) { app.process_books(data) }

    context "with a value of false" do
      let(:data) { false }

      it "returns an empty array" do
        expect(processed_books).to eq([])
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

      it "returns an array of five books, each with title, authors, and publisher information" do
        expect(processed_books).to eq(processed_books_array)
      end
    end
  end

  describe "#stdout" do
    let(:result) { app.stdout(processed_books, type) }

    context "with no processed books" do
      let(:processed_books) { [] }
      let(:type) { "Reading List" }

      it "outputs no result to stdout" do 
        expect { result }.to output("Reading List is empty\n").to_stdout
      end
    end

    context "with one result and some information blank" do
      let(:processed_books) { [{ "title" => "Flowers", "authors" => [], "publisher" => "Capstone" }] }
      let(:type) { "Reading List" }

      it "outputs one result to stdout" do
        expect { result }.to output(
          "Reading List\n-----\n1\n" +
          "Title: Flowers\nAuthors: \nPublisher: Capstone\n-----\n"
        ).to_stdout
      end
    end

    context "with five results and some information blank" do
      let(:processed_books) { processed_books_array }
      let(:type) { "Search List" }

      it "outputs five results to stdout" do
        expect { result }.to output(
          "Search List\n-----\n1\n" +
          "Title: Flowers\nAuthors: \nPublisher: Capstone\n-----\n2\n" +
          "Title: On Flowers\nAuthors: Amy Merrick\nPublisher: \n-----\n3\n" +
          "Title: Bee's Flowers\nAuthors: Corlet Dawn\nPublisher: Corlet Dawn\n-----\n4\n" +
          "Title: Flowers\nAuthors: Paul McEvoy\nPublisher: Blake Education\n-----\n5\n" +
          "Title: Flowers in the Attic\nAuthors: V.C. Andrews\nPublisher: Simon and Schuster\n-----\n"
        ).to_stdout
      end
    end
  end

  describe "#search_results" do
    after(:each) do
      $stdin = STDIN
    end

    context "with search results" do
      it "outputs search results to stdout" do
        $stdin = StringIO.new("1.3333333333333333333\n")
        expect { app.search_results }.to output(
          "Please enter a search term.\n" +
          "Search List\n-----\n1\n" +
          "Title: Return of the Old Ones\nAuthors: Brian Sammons\nPublisher: \n-----\n"
        ).to_stdout
      end
    end

    context "with no search results" do
      it "outputs a message with no search results" do
        $stdin = StringIO.new("tokillamockingbird40th\n")
        expect { app.search_results }.to output(
          "Please enter a search term.\n" +
          "Search List is empty\n"
        ).to_stdout
      end
    end
  end

  describe "#reading_list" do
    let(:processed_books) { processed_books_array }
    let(:reading_list) { app.reading_list(processed_books) }
    after(:each) do
      $stdin = STDIN
    end

    context "if the user indicates yes" do
      it "outputs the user's reading list to stdout" do
        $stdin = StringIO.new("yes\n1\n")
        expect { reading_list }.to output(
          "Do you want to add a book from the search results to your reading list?  Enter yes or y or no or n.\n" +
          "Enter the book's number (above title) to add a book to your reading list.\n" +
          "Reading List\n-----\n1\n" +
          "Title: Flowers\nAuthors: \nPublisher: Capstone\n-----\n"
        ).to_stdout
      end
    end

    context "if the user indicates no" do
      it "does not output the user's reading list to stdout" do
        $stdin = StringIO.new("no\n1\n")
        expect { reading_list }.to output(
          "Do you want to add a book from the search results to your reading list?  Enter yes or y or no or n.\n"
        ).to_stdout
      end
    end
  end

  describe "#run" do
    let(:run) { app.run }
    after(:each) do
      $stdin = STDIN
    end

    context "if the user indicates no to a search" do
      it "outputs goodbye to stdout and ends the program" do
        $stdin = StringIO.new("no\n")
        expect { run }.to output(
          "Do you want to search books?  Enter yes or y or no or n.\n" +
          "Goodbye.\n"
        ).to_stdout
      end
    end

    context "if the user indicates yes, and the search results are empty" do
      it "prompts user for another search" do
        $stdin = StringIO.new("yes\ntokillamockingbird40th\nno\n")
        expect { run }.to output(
          "Do you want to search books?  Enter yes or y or no or n.\n" +
          "Please enter a search term.\n" +
          "Search List is empty\n" +
          "Do you want to search books?  Enter yes or y or no or n.\n" +
          "Goodbye.\n"
        ).to_stdout
      end
    end

    context "with search results, if the user indicates yes to add to reading list" do
      it "prompts the user to add to a reading list, shows the reading list, and prompts for search again" do
        $stdin = StringIO.new("yes\n1.3333333333333333333\nyes\n1\nno\n")
        expect { run }.to output(
          "Do you want to search books?  Enter yes or y or no or n.\n" +
          "Please enter a search term.\n" +
          "Search List\n-----\n1\n" +
          "Title: Return of the Old Ones\nAuthors: Brian Sammons\nPublisher: \n-----\n" +
          "Do you want to add a book from the search results to your reading list?  Enter yes or y or no or n.\n" +
          "Enter the book's number (above title) to add a book to your reading list.\n" +
          "Reading List\n-----\n1\n" +
          "Title: Return of the Old Ones\nAuthors: Brian Sammons\nPublisher: \n-----\n" +
          "Do you want to search books?  Enter yes or y or no or n.\n" +
          "Goodbye.\n"
        ).to_stdout
      end
    end
  end
end