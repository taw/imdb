require "pathname"

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

desc "Download imdb data (unless already done)"
task "download" do
  download_file_list
  file_list.each do |file|
    download_and_unpack(file)
  end
end
