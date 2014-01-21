require_relative 'movie_data'

  data = MovieData.new
  
  data.load_data()
  
  p data.most_similar(196)
  
  #data.test()
  
  #p data.popularity_list