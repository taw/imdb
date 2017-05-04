require "pathname"
require "csv"

class ImdbParser
  def initialize(path)
    @path = path
  end

  def open
    @path.open("r:iso-8859-1:utf-8") do |fh|
      yield(fh)
    end
  end

  def each_line
    open do |fh|
      fh.each_line do |line|
        line.chomp!
        next unless line =~ /\t/
        yield(line)
      end
    end
  end
end

class GenresParser < ImdbParser
  def each_line
    in_headers = true
    open do |fh|
      fh.each_line do |line|
        line.chomp!
        if in_headers
          in_headers = false if line =~ /8: THE GENRES LIST/
          next
        end
        next unless line =~ /\t/
        yield(line)
      end
    end
  end
end

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
      input_parser.each_line do |line|
        values = line.split(/\t+/)
        if values.size > @headers.size
          raise "Too many columns found - #{values.size} found, #{headers.size} expected"
        end
        csv << values
      end
    end
  end
end

def download(file_name)
  Pathname("database").mkpath
  url = "ftp://ftp.fu-berlin.de/pub/misc/movies/database/#{file_name}"
  output_path = Pathname("database/#{file_name}")
  return if output_path.exist?
  system "wget", "-nv", "-nc", url, "-O", output_path.to_s
end

def download_and_unpack(file_name)
  output_path = Pathname("database/#{file_name}")
  return if output_path.exist?
  download("#{file_name}.gz")
  system "gunzip", "database/#{file_name}.gz"
end

def file_list
  file_list_path = Pathname("database/filesizes")
  raise "File list not downloaded" unless file_list_path.exist?
  file_list_path.readlines.map{|line| line.chomp.split(" ")[0]}.sort
end

def download_file_list
  # Use this as index
  download "filesizes"
end

def export_to_csv(table_name)
  case table_name
  when "language"
    CSVExporter.new(table_name, "title", "language", "comment").call
  when "locations"
    CSVExporter.new(table_name, "title", "location", "comment").call
  when "genres"
    CSVExporter.new(table_name, "title", "genre", parser: GenresParser).call
  when "distributors"
    CSVExporter.new(table_name, "title", "distributor", "distribution scope").call
  when "complete-cast"
    CSVExporter.new(table_name, "title", "complete cast").call
  when "complete-crew"
    CSVExporter.new(table_name, "title", "complete crew").call
  when "miscellaneous-companies.list"
    CSVExporter.new(table_name, "title", "company", "company role").call
  else
    warn "No idea how to import #{table_name}"
  end
end

desc "Download imdb data (unless already done)"
task "download" do
  download_file_list
  file_list.each do |file|
    download_and_unpack(file)
  end
end

desc "Export data to csv"
task "export:csv" => "download" do
  file_list.each do |file_name|
    table_name = file_name.sub(/\.list\z/, "")
    export_to_csv(table_name)
  end
end
