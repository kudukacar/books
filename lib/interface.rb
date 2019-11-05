module Interface
  def output(message)
    puts message
  end

  def input
    $stdin.gets.strip
  end
end