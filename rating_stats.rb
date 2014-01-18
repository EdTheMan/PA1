require_relative 'movie_data'

  data = MovieData.new
  
  data.load_data()
  
  #p data.similarity(196,244)
  
  #data.test()
  
  p data.most_similar(196)
