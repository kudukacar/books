module Output
  def stdout(books, type)
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