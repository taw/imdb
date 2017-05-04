class TechnicalParser < ImdbParser
  def header_patterns
    [/TECHNICAL LIST/]
  end
end
