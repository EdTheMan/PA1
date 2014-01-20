require_relative 'movie_data'

  data = MovieData.new
  
  data.load_data()
  
  p data.popularity_list
  
  #data.test()
  
  #p data.popularity_list