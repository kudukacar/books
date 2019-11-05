module Output
  def stdout(books, type)

    if !books
      return puts "Search encountered an error. "  +
      "Please confirm you inputed your API key, and are connected to the internet."
    end

    return puts "#{type} is empty" if books.empty?

    puts "#{type}\n-----"
    books.each_with_index do |book, i|
      title = book["title"]
      authors = book["authors"] || []
      publisher = book["publisher"]
      puts "#{i + 1}\nTitle: #{title}\nAuthors: #{authors.join(", ")}\nPublisher: #{publisher}\n-----"
    end
  end
end