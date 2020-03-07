require_relative "../config/environment"

Artist.all.order(:name).each do |artist|
  artist.albums.order(:title).each do |album|
    puts "#{artist.name} -- #{album.title}"
  end
end
