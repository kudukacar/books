require_relative "./output"
require_relative "./interface"

class User
  attr_reader :reading_list

  include Interface

  def initialize
    @reading_list = []
  end

  def query?
    loop do
      output("Do you want to search books?  Enter yes or y or no or n.")

      answer = input.downcase

      if answer == "y" || answer == "yes"
        return true
      elsif answer == "n" || answer == "no"
        return false
      else
        output("Invalid entry.")
      end
    end
  end

  def query
    loop do
      output("Please enter a search term.")

      search_term = input

      if search_term != ""
        return search_term
      else
        output("Invalid entry.")
      end
    end
  end

  def add_to_list?
    loop do
      output("Do you want to add a book from the search results to your reading list?  Enter yes or y or no or n.")

      answer = input.downcase

      if answer == "y" || answer == "yes"
        return true
      elsif answer == "n" || answer == "no"
        return false
      else
        output("Invalid entry.")
      end
    end
  end

  def add_to_list(total_results)
    loop do
      output("Enter the book's number (above title) to add a book to your reading list.")
      
      selection = Integer(input) rescue 0

      if selection.between?(1, total_results)
        return selection
      else
        output("Invalid entry.")
      end
    end
  end

  def append_list(selected_books)
    @reading_list = @reading_list.concat(selected_books).uniq
  end
end