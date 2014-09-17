require "json"
require "open-uri"
require "date"


def set_desktop_image(path)
  `osascript -e 'tell application \"System Events\" to set picture of every desktop to \"#{path}\"'`
end


def setup_image_directory
  path = File.expand_path("~/Pictures/BingImages")
  unless Dir.exist? path
    Dir.mkdir path
  end
end


def image_dir
  File.expand_path("~/Pictures/BingImages")
end

def api_url(day_offset = 0)
  "http://www.bing.com/HPImageArchive.aspx?format=js&idx=#{day_offset}&n=1&mkt=en-US"
end


def get_image_url(day_offset = 0)
  response = open(api_url(day_offset))

  json = JSON.parse(response.read)

  image_url = json["images"][0]["url"]

  "http://www.bing.com#{image_url}"
end

def fetch_image(day_offset = 0) 
  image_url = get_image_url(day_offset)

  filetype = image_url.match(/\.(\w*)$/)[1]
  filebase = (Date.today - day_offset).to_s
  
  dest_file = File.join(image_dir, "#{filebase}.#{filetype}") 

  image_stream = open(image_url)
  file = open(dest_file, "w")
  file.write(image_stream.read)
  file.close

  dest_file
end

setup_image_directory
set_desktop_image fetch_image

