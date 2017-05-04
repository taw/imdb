require "pathname"
require "csv"
require_relative "lib/imdb_parser"
require_relative "lib/companies_parser"
require_relative "lib/credits_parser"
require_relative "lib/genres_parser"
require_relative "lib/keywords_parser"
require_relative "lib/technical_parser"
require_relative "lib/ratings_parser"
require_relative "lib/csv_exporter"

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
  when "actors", "actresses", "cinematographers", "composers", "costume-designers", "directors", "editors", "miscellaneous", "producers", "production-designers", "writers"
    CSVExporter.new(table_name, "name", "title", "comment", parser: CreditsParser).call
  when "production-companies", "miscellaneous-companies", "special-effects-companies"
    CSVExporter.new(table_name, "title", "company", "comment", parser: CompaniesParser).call
  when "certificates"
    CSVExporter.new(table_name, "title", "certificate", "comment").call
  when "color-info"
    CSVExporter.new(table_name, "title", "color", "comment").call
  when "complete-cast"
    CSVExporter.new(table_name, "title", "complete cast").call
  when "complete-crew"
    CSVExporter.new(table_name, "title", "complete crew").call
  when "countries"
    CSVExporter.new(table_name, "title", "country").call
  when "distributors"
    CSVExporter.new(table_name, "title", "distributor", "distribution scope").call
  when "genres"
    CSVExporter.new(table_name, "title", "genre", parser: GenresParser).call
  when "keywords"
    CSVExporter.new(table_name, "title", "keyword", parser: KeywordsParser).call
  when "language"
    CSVExporter.new(table_name, "title", "language", "comment").call
  when "locations"
    CSVExporter.new(table_name, "title", "location", "comment").call
  when "movies"
    CSVExporter.new(table_name, "title", "date").call
  when "ratings"
    CSVExporter.new(table_name, "new", "distribution", "votes", "rank", "title", parser: RatingsParser).call
  when "release-dates"
    CSVExporter.new(table_name, "title", "release date", "comment").call
  when "running-times"
    CSVExporter.new(table_name, "title", "running time", "comment").call
  when "sound-mix"
    CSVExporter.new(table_name, "title", "sound", "comment").call
  when "technical"
    CSVExporter.new(table_name, "title", "technical", "comment", parser: TechnicalParser).call
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
