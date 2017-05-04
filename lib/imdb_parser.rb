class ImdbParser
  def initialize(path)
    @path = path
  end

  def open
    @path.open("r:iso-8859-1:utf-8") do |fh|
      yield(fh)
    end
  end

  def header_patterns
    []
  end

  def each_line
    waiting_for_headers = header_patterns
    open do |fh|
      fh.each_line do |line|
        line.chomp!
        unless waiting_for_headers.empty?
          waiting_for_headers.shift if line =~ waiting_for_headers[0]
          next
        end
        yield(line)
      end
    end
  end

  def each_row
    each_line do |line|
      next unless line =~ /\t/
      yield(line.split(/\t+/))
    end
  end
end
