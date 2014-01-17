class Rating

  attr_reader :user_id, :movie_id, :rating, :timestamp, :similarity
  
  def initialize(user_id, movie_id, rating, timestamp)
    
    @user_id = user_id
    @movie_id = movie_id
    @rating = rating
    @timestamp = timestamp
    @similarity = 0
  
  end
  
  def change_similarity(similarity)
  
    @similarity = similarity
  
  end
  

end