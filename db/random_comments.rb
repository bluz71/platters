20.times do
  album = Album.random.first
  album.comments.create(user: User.find(rand(3..51)),
                        body: Faker::Hipster.paragraph[0..280])
end
