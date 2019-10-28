class User
  attr_accessor :reading_list

  def initialize
    @reading_list = []
  end

  def query?
    loop do
      puts "Do you want to search books?  Enter yes or y or no or n."

      answer = $stdin.gets.downcase.strip

      if answer == "y" || answer == "yes"
        return true
      elsif answer == "n" || answer == "no"
        return false
      else
        puts "Invalid entry."
      end
    end
  end

  def query
    loop do
      puts "Please enter a search term."

      search_term = $stdin.gets.strip

      if search_term != ""
        return search_term
      else
        puts "Invalid entry."
      end
    end
  end

  def add_to_list?
    loop do
      puts "Do you want to add a book from the search results to your reading list?  Enter yes or y or no or n."

      answer = $stdin.gets.downcase.strip

      if answer == "y" || answer == "yes"
        return true
      elsif answer == "n" || answer == "no"
        return false
      else
        puts "Invalid entry."
      end
    end
  end

  def add_to_list(total_results)
    loop do
      puts "Enter the book's number (above title) to add a book to your reading list."
      
      selection = Integer($stdin.gets.strip) rescue 0

      if selection.between?(1, total_results)
        return selection
      else
        puts "Invalid entry."
      end
    end
  end

  def append_list(selected_books)
    self.reading_list = self.reading_list.concat(selected_books).uniq
  end
end