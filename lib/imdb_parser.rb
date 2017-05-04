class ImdbParser
  def initialize(path)
    @path = path
  end

  def open
    @path.open("r:iso-8859-1:utf-8") do |fh|
      yield(fh)
    end
  end

  def each_row
    open do |fh|
      fh.each_line do |line|
        line.chomp!
        next unless line =~ /\t/
        yield(line.split(/\t+/))
      end
    end
  end
end
