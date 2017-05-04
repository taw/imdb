class GenresParser < ImdbParser
  def header_patterns
    [/8: THE GENRES LIST/]
  end
end
