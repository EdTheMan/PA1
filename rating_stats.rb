require_relative 'movie_data'

  data = MovieData.new
  
  data.load_data()
  
  #puts(data.get_rating(0))
  
  data.test()
  
  #data.most_similar(196)
