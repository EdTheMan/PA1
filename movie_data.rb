require_relative 'rating'

class MovieData
  
  def initialize
    @listOfRatings = []
    @numberOfRatingsHash = Hash.new(0)
    @moviesHash = Hash.new {|h,k| h[k] = Array.new }
    @timestampHash = Hash.new {|h,k| h[k] = Array.new }
    @avgTimestampHash = Hash.new
    @popularityHash = Hash.new
    @scaleAvgTimestamp = 10000000000 #2 years gives about 6 rating 
    @noRating = 6
    
  end
  
  def load_data()

   
     text = File.open('C:\Users\Eddie\Desktop\cosi 236b\ml-100k\u.data').read
     text.each_line do |line|
       
       @listOfRatings << Rating.new(Integer(line.split(" ")[0]),Integer(line.split(" ")[1]),Integer(line.split(" ")[2]),Integer(line.split(" ")[3]))
       
     end
     
    #maps each movie id to its number of ratings
    #note that each key in the hashes are INTEGER values
    @listOfRatings.each do |key| 
        @numberOfRatingsHash[key.movie_id] = @numberOfRatingsHash[key.movie_id] + 1
        #puts(Integer(key.movie_id))
    end

    #maps user_id to an array of movie_ids
    @listOfRatings.each do |key| 
       @moviesHash[key.user_id] << (key.movie_id)
    end


    #puts each movie_id's timestamps into an ARRAY mapped by the movie_id
    @listOfRatings.each do |key| 
       @timestampHash[key.movie_id] << (key.timestamp)
    end
    
    #each key is a movie_id that maps to its average timestamp
    @timestampHash.each do |key, value|
       @avgTimestampHash[key] = (@timestampHash[key].inject{ |sum, el| sum + el }.to_f / @timestampHash[key].size) 
    end
    
    #gets all the popularity of each movie id by the formula average timestamp/ 100000000 + number of ratings
    @avgTimestampHash.each do |key, value|
        @popularityHash[key] = ((@avgTimestampHash[key]  / @scaleAvgTimestamp)) + (@numberOfRatingsHash[key])
    end
    
     
  end
  
  def popularity(movie_id)
     
     p "Number of Ratings - #{@numberOfRatingsHash[movie_id]}"
     p ""
     p "Average time - #{@avgTimestampHash[movie_id]}"
     p ""
     p "Popularity - #{@popularityHash[movie_id]}"
     p ""
      

  end
  
  def popularity_list

    p (Hash[@popularityHash.sort_by{|k, v| v}.reverse])
    
  end
  
  
  def similarity(user1,user2)
    
    similarity = 0
    
    @moviesHash[user1].each do |value|
      
      if(@moviesHash[user2].include?(value))
        
        ratingUser1 = 0
        ratingUser2 = 0
        
        
        @listOfRatings.each do |key|
          
          
          if((key.movie_id == value) and (key.user_id == user1))
            
            ratingUser1 = key.rating
          
          end
        
          if((key.movie_id == value) and (key.user_id == user2))
            
            ratingUser2 = key.rating
          
          end
          
        end
        
        similarity = similarity + (1.0 / (1.0+ ((ratingUser1 - ratingUser2).abs)))
        
        
      else
        
        similarity = similarity + (1.0 / (1.0 + @noRating))
        
      end
      
      
        
    end
      
    return similarity
    
  end
  
  def most_similar(user)
    
    similaritiesArray = []
    
      @moviesHash.each do |key,value|
      
      x = Rating.new(key,2,3,4)
      
      x.change_similarity(similarity(user,key))
      
      similaritiesArray << x
       
      end
    
    a = similaritiesArray.sort_by {|obj| obj.similarity}.reverse
  
    p a
    

    
    
  end
  
  
  def get_rating(index) 
        
    return "User_id : #{@listOfRatings[index].user_id}"\
    " , Movie_id : #{@listOfRatings[index].movie_id}"\
    " , Rating : #{@listOfRatings[index].rating}"\
    " , Timestamp : #{@listOfRatings[index].timestamp}"
    
  end
   
  
end