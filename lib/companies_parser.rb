class CompaniesParser < ImdbParser
  def each_row
    open do |fh|
      fh.each_line do |line|
        line.chomp!
        next unless line =~ /\t/
        row = line.split(/\t+/, 3)
        # There are some weirdo entries like:
        # ["Zwischen Kino und Konzert - Der Komponist Nino Rota (1993)", "Medias Res Filmproduktion [de]", "(as ", " Medias Res Film- und Fernsehproduktion München)"]
        # Fix them to:
        # ["Zwischen Kino und Konzert - Der Komponist Nino Rota (1993)", "Medias Res Filmproduktion [de]", "(as Medias Res Film- und Fernsehproduktion München)"]
        # etc.
        row[2].gsub!(/\s*\t\s*/, " ") if row[2]
        yield(row)
      end
    end
  end
end
