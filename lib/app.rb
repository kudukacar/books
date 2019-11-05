require "dotenv/load"
require_relative "./user"
require_relative "./search"
require_relative "./interface"
require_relative "./output"

class App
  include Output
  include Interface

  def initialize(limit)
    @limit = limit
    @user = User.new
  end

  def reading_list(search_results)
    if @user.add_to_list?
      selection = @user.add_to_list(search_results.length)
      @user.append_list([search_results[selection - 1]])
      stdout(@user.reading_list, "Reading List")
    end
  end

  def run
    loop do
      if @user.query?
        search = Search.new(@limit, @user.query)
        results = search.search_results
        stdout(results, "Search List")
        if results
          reading_list(results) if !results.empty?
        end
      else
        output("Goodbye.")
        return
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
    App.new(5).run
end