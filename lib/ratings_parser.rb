class RatingsParser < ImdbParser
  def header_patterns
    [/New  Distribution  Votes  Rank  Title/] * 3
  end

  def each_row
    each_line do |line|
      break if line =~ /------------------------------------------------------------------------------/
      yield(line.split(/\s+/, 5))
    end
  end
end
