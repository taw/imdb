class CSVExporter
  def initialize(table_name, *headers, parser: ImdbParser)
    @table_name = table_name
    @headers = headers
    @parser_class = parser
  end

  def input_path
    Pathname("database/#{@table_name}.list")
  end

  def output_path
    Pathname("csv/#{@table_name}.csv")
  end

  def input_parser
    @parser_class.new(input_path)
  end

  def call
    raise "No such file: #{input_path}" unless input_path.exist?
    return if output_path.exist?
    output_path.parent.mkpath
    CSV.open(output_path.to_s, "wb") do |csv|
      csv << @headers
      input_parser.each_row do |values|
        if values.size > @headers.size
          binding.pry
          raise "Too many columns found - #{values.size} found, #{@headers.size} expected"
        end
        csv << values
      end
    end
  end
end
