class User
  attr_accessor :reading_list

  def initialize
    @reading_list = []
  end

  def query
    loop do
      puts "Please enter a term to search for books."

      search_term = gets.chomp

      if search_term != ""
        return search_term
      else
        puts "Invalid entry."
      end
    end
  end

  def append_list(total_results)
    loop do
      puts "Enter the book's number (above title) to add the book to your reading list.  Select multiple books by separating each number with a comma.  For example, 1, 3." 

      selected_books = gets.chomp.split(",").map do |selected_book|
        selected_book.to_i
      end

      selected_books = selected_books.uniq

      valid = selected_books.all? { |selected_book| selected_book.between?(1, total_results) }

      if valid
        return selected_books
      else
        puts "Invalid selection."
      end
    end
  end
end