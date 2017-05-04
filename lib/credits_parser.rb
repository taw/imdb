class CreditsParser < ImdbParser
  def header_patterns
    [/\A----\s+------\z/]
  end

  def each_row
    last_credits = nil
    each_line do |line|
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
