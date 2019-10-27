module Output
  def stdout(books, type)
    return puts "#{type} is empty" if books.empty?

    puts "#{type}\n-----"
    books.each_with_index do |book, i|
      puts "#{i + 1}\nTitle: #{book["title"]}\nAuthors: #{book["authors"].join(", ")}\nPublisher: #{book["publisher"]}\n-----"
    end
  end
end