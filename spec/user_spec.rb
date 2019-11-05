require "rspec"
require "user"
require "stringio"

describe User do
  subject(:user) { User.new }

  describe "#initialize" do
    it "sets up the reading list" do
      expect(user.reading_list).to eq([])
    end
  end

  describe "#output" do
    let(:message) { "Please enter a search term." } 
    it "prints a message to stdout" do
      expect { user.output(message) }.to output(
        "Please enter a search term.\n"
      ).to_stdout
    end
  end

  describe "#input" do
    after(:each) do
      $stdin = STDIN
    end

    it "returns the user's stripped response" do
      $stdin = StringIO.new("yes\n")
      expect(user.input).to eq("yes")
    end 
  end

  describe "#query?" do 
    let(:query?) { user.query? }  
    after(:each) do
        $stdin = STDIN
    end

    context "with multiple invalid entries and one valid entry" do
      after(:each) do
        $stdout = STDOUT
      end
      it "prompts the user for input until receiving a valid entry" do
        $stdout = StringIO.new
        $stdin = StringIO.new("hi\n4\nn\n")
        expect(query?).to eq(false)
        expect($stdout.string).to eq(
          "Do you want to search books?  Enter yes or y or no or n.\n" +
          "Invalid entry.\nDo you want to search books?  Enter yes or y or no or n.\n" +
          "Invalid entry.\nDo you want to search books?  Enter yes or y or no or n.\n"
        )
      end
    end

    context "with a valid entry of yes" do
      it "returns the user input" do
        $stdin = StringIO.new("yes\n")
        expect(query?).to eq(true)
      end
    end

    context "with a valid entry of y" do
      it "returns the user input" do
        $stdin = StringIO.new("y\n")
        expect(query?).to eq(true)
      end
    end

    context "with a valid entry of no" do
      it "returns the user input" do
        $stdin = StringIO.new("no\n")
        expect(query?).to eq(false)
      end
    end

    context "with a valid entry of n" do
      it "returns the user input" do
        $stdin = StringIO.new("n\n")
        expect(query?).to eq(false)
      end
    end
  end

  describe "#query" do
    let(:query) { user.query }
    after(:each) do
      $stdin = STDIN
    end

    context "with multiple invalid entries and one valid entry" do
      after(:each) do
        $stdout = STDOUT
      end
      it "prompts the user for input until receiving a valid entry" do
        $stdout = StringIO.new
        $stdin = StringIO.new("\n\nflowers\n")
        expect(query).to eq("flowers")
        expect($stdout.string).to eq(
          "Please enter a search term.\nInvalid entry.\nPlease enter a search term.\n" +
          "Invalid entry.\nPlease enter a search term.\n"
        )
      end
    end

    context "with a valid entry" do
      it "returns the user input" do
        $stdin = StringIO.new("flowers\n")
        expect(query).to eq("flowers")
      end
    end
  end

  describe "#add_to_list?" do 
    let(:add_to_list?) { user.add_to_list? }  
    after(:each) do
      $stdin = STDIN
    end

    context "with multiple invalid entries and one valid entry" do
      after(:each) do
        $stdout = STDOUT
      end
      it "prompts the user for input until receiving a valid entry" do
        $stdout = StringIO.new
        $stdin = StringIO.new("hi\n4\nn\n")
        expect(add_to_list?).to eq(false)
        expect($stdout.string).to eq(
          "Do you want to add a book from the search results to your reading list?  " +
          "Enter yes or y or no or n.\n" +
          "Invalid entry.\nDo you want to add a book from the search results to your reading list?  " +
          "Enter yes or y or no or n.\n" +
          "Invalid entry.\nDo you want to add a book from the search results to your reading list?  " +
          "Enter yes or y or no or n.\n"
        )
      end
    end

    context "with a valid entry of yes" do
      it "returns the user input" do
        $stdin = StringIO.new("yes\n")
        expect(add_to_list?).to eq(true)
      end
    end

    context "with a valid entry of y" do
      it "returns the user input" do
        $stdin = StringIO.new("y\n")
        expect(add_to_list?).to eq(true)
      end
    end

    context "with a valid entry of no" do
      it "returns the user input" do
        $stdin = StringIO.new("no\n")
        expect(add_to_list?).to eq(false)
      end
    end

    context "with a valid entry of n" do
      it "returns the user input" do
        $stdin = StringIO.new("n\n")
        expect(add_to_list?).to eq(false)
      end
    end
  end

  describe "#add_to_list" do
    let(:add_to_list) { user.add_to_list(5) }
    after(:each) do
      $stdin = STDIN
    end

    context "with multiple invalid entries and one valid entry" do
      after(:each) do
        $stdout = STDOUT
      end
      it "prompts the user for input until receiving a valid entry" do
        $stdout = StringIO.new
        $stdin = StringIO.new("4, 6\n7\n1\n")
        expect(add_to_list).to eq(1)
        expect($stdout.string).to eq(
          "Enter the book's number (above title) to add a book to your reading list.\nInvalid entry.\n" +
          "Enter the book's number (above title) to add a book to your reading list.\nInvalid entry.\n" +
          "Enter the book's number (above title) to add a book to your reading list.\n"
        )
      end
    end

    context "with a single valid entry" do
      it "returns the user input" do
        $stdin = StringIO.new("1\n")
        expect(add_to_list).to eq(1)
      end
    end
  end

  describe "#append_list" do
    let(:first_selection) { [{ "title" => "Flowers", "authors" => [], "publisher" => "Capstone" }] }
    let(:second_selection) { [{ "title" => "Flowers in the Attic", "authors" => ["V.C. Andrews"], "publisher" => "Simon and Schuster" }] }
    before(:each) do
      user.append_list(first_selection)
    end

    it "adds the selection to the user's reading list" do
      expect(user.append_list(second_selection)).to eq([
        { "title" => "Flowers", "authors" => [], "publisher" => "Capstone" },
        { "title" => "Flowers in the Attic", "authors" => ["V.C. Andrews"], "publisher" => "Simon and Schuster" }
      ])
    end

    it "does not add duplicates to the user's reading list" do
      expect(user.append_list(first_selection)).to eq(first_selection)
    end
  end
end