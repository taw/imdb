class CreditsParser < ImdbParser
  def each_row
    open do |fh|
      in_headers = true
      last_credits = nil
      fh.each_line do |line|
        line.chomp!
        if in_headers
          in_headers = false if line =~ /\A----\s+------\z/
          next
        end
        next unless line =~ /\t/
        row = line.split(/\t+/)
        if row[0] == ""
          row[0] = last_credits
        else
          last_credits = row[0]
        end
        yield(row)
      end
    end
  end
end
