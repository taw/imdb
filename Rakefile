require "pathname"
require "csv"

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

def export_to_csv_generic(file_name, *headers)
  input_path = Pathname("database/#{file_name}.list")
  output_path = Pathname("csv/#{file_name}.csv")
  output_path.parent.mkpath
  raise "No such file: #{input_path}" unless input_path.exist?
  return if output_path.exist?
  input_path.open("r:iso-8859-1:utf-8") do |input_fh|
    CSV.open(output_path.to_s, "wb") do |csv|
      csv << headers
      input_fh.each_line do |line|
        line.chomp!
        next unless line =~ /\t/
        values = line.split(/\t+/)
        if values.size > headers.size
          raise "Too many columns found - #{values.size} found, #{headers.size} expected"
        end
        csv << values
      end
    end
  end
end

def export_to_csv(table_name)
  case table_name
  when "language"
    export_to_csv_generic(table_name, "title", "language", "comment")
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
