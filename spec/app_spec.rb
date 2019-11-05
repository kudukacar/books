require "rspec"
require "app"
require "user"
require "dotenv/load"
require "stringio"

describe App do
  subject(:app) { App.new(5) }

  describe "#stdout" do
    let(:result) { app.stdout(processed_books, type) }

    context "with a search error" do
      let(:processed_books) { false }
      let(:type) { "Search List" }

      it "outputs an error message to stdout" do
        expect { result }.to output(
          "Search encountered an error. "  +
          "Please confirm you inputed your API key, and are connected to the internet.\n"
        ).to_stdout
      end
    end

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
      let(:processed_books) {[
        { "title" => "Flowers", "authors" => nil, "publisher" => "Capstone" },
        { "title" => "On Flowers", "authors" => ["Amy Merrick"], "publisher" => nil },
        { "title" => "Bee's Flowers", "authors" => ["Corlet Dawn"], "publisher" => "Corlet Dawn" },
        { "title" => "Flowers", "authors" => ["Paul McEvoy"], "publisher" => "Blake Education" },
        { "title" => "Flowers in the Attic", "authors" => ["V.C. Andrews"], "publisher" => "Simon and Schuster" }
      ]}
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

  describe "#reading_list" do
    let(:processed_books) {[
      { "title" => "Flowers", "authors" => nil, "publisher" => "Capstone" },
      { "title" => "On Flowers", "authors" => ["Amy Merrick"], "publisher" => nil },
      { "title" => "Bee's Flowers", "authors" => ["Corlet Dawn"], "publisher" => "Corlet Dawn" },
      { "title" => "Flowers", "authors" => ["Paul McEvoy"], "publisher" => "Blake Education" },
      { "title" => "Flowers in the Attic", "authors" => ["V.C. Andrews"], "publisher" => "Simon and Schuster" }
    ]}
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

    context "if the user indicates yes, and there is a search error" do
      it "prompts user for another search" do
        api_key_orig = ENV["GOOGLE_BOOKS_KEY"]
        ENV["GOOGLE_BOOKS_KEY"] = "hello"
        $stdin = StringIO.new("yes\ntokillamockingbird40th\nno\n")
        expect { run }.to output(
          "Do you want to search books?  Enter yes or y or no or n.\n" +
          "Please enter a search term.\n" +
          "Search encountered an error. " +
          "Please confirm you inputed your API key, and are connected to the internet.\n" +
          "Do you want to search books?  Enter yes or y or no or n.\n" +
          "Goodbye.\n"
        ).to_stdout
        ENV["GOOGLE_BOOKS_KEY"] = api_key_orig
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

    context "with search results, if the user indicates no to add to reading list" do
      it "prompts the user for search again" do
        $stdin = StringIO.new("yes\n1.3333333333333333333\nno\nno\n")
        expect { run }.to output(
          "Do you want to search books?  Enter yes or y or no or n.\n" +
          "Please enter a search term.\n" +
          "Search List\n-----\n1\n" +
          "Title: Return of the Old Ones\nAuthors: Brian Sammons\nPublisher: \n-----\n" +
          "Do you want to add a book from the search results to your reading list?  Enter yes or y or no or n.\n" +
          "Do you want to search books?  Enter yes or y or no or n.\n" +
          "Goodbye.\n"
        ).to_stdout
      end
    end
  end
end