class GenresParser < ImdbParser
  def each_row
    in_headers = true
    open do |fh|
      fh.each_line do |line|
        line.chomp!
        if in_headers
          in_headers = false if line =~ /8: THE GENRES LIST/
          next
        end
        next unless line =~ /\t/
        yield(line.split(/\t+/))
      end
    end
  end
end
