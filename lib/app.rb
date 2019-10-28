require "dotenv/load"
require_relative "./api"
require_relative "./process"
require_relative "./output"
require_relative "./user"

class App
  attr_reader :user, :limit

  include API
  include ProcessData
  include Output

  def initialize(limit)
    @limit = limit
    @user = User.new
  end

  def search_params
    query = self.user.query
    api_key = ENV["GOOGLE_BOOKS_KEY"]
    params = { 
      "q" => query, 
      "maxResults" => self.limit, 
      "key" => api_key 
    }
  end

  def search_results
    data = get_books(search_params)
    processed_books = process_books(data)
    stdout(processed_books, "Search List")
    processed_books
  end

  def reading_list(results)
    if self.user.add_to_list?
      selection = self.user.add_to_list(results.length)

      selected_books = [results[selection - 1]]

      self.user.append_list(selected_books)
      stdout(self.user.reading_list, "Reading List")
    end
  end

  def run
    loop do
      if self.user.query?
        results = search_results
        reading_list(results) if !results.empty?
      else
        puts "Goodbye."
        return
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
    App.new(5).run
end