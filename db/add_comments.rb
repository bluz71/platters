artist = Artist.find(1234)
rand(50).times do
  comment = artist.comments.create(user: User.find(rand(3..52)),
                                   body: Faker::Hipster.paragraph[0..280])
  comment.update_attribute(:created_at, (rand + rand(300)).days.ago)
end

album = Album.find(1234)
rand(50).times do
  comment = album.comments.create(user: User.find(rand(3..52)),
                                  body: Faker::Hipster.paragraph[0..280])
  comment.update_attribute(:created_at, (rand + rand(300)).days.ago)
end
