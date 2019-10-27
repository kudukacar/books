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

  describe "#query" do
    context "with a valid query" do
      it "returns the user input" do
        allow(user).to receive(:gets) { "flowers\n" }
        expect(user.query).to eq("flowers")
      end
    end
  end

  describe "#append_list" do
    context "with a single valid entry" do
      it "returns the user input" do
        allow(user).to receive(:gets) { "1" }
        expect(user.append_list(5)).to eq([1])
      end
    end

    context "with multiple valid entries" do
      it "returns the user input" do
        allow(user).to receive(:gets) { "1, 2, 3" }
        expect(user.append_list(5)).to eq([1, 2, 3])
      end
    end

    context "with multiple duplicate valid entries" do
      it "returns the user input" do
        allow(user).to receive(:gets) { "1, 1, 2, 2"}
        expect(user.append_list(5)).to eq([1, 2])
      end
    end
  end
end