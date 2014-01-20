#Chi Ieong (Eddie) Tai
#teddy123168@gmail.com
#1/20/14
#Pito Salas
#This class is used to determine the popularity of a movie and the similarity
#between users using a text file.

class MovieData
  
  #initializes Hashes and variables
  def initialize
    @userHash = Hash.new {|h,k| h[k] = Hash.new } #hash where user maps to a hash that maps movie_id to its rating by the user
    @numberOfRatingsHash = Hash.new(0) #hash that maps a movie to the number of rating it has
    @timestampHash = Hash.new {|h,k| h[k] = Array.new } #hash that maps movie id to an array of its timestamps of when it was rated.
    @avgTimestampHash = Hash.new #hash that maps the movie_id to the average timestamp of when it was rated (see popularity_list())
    @popularityHash = Hash.new #hash that maps movie_id to its popular given by the formula (Average timestamp/ @scaleAvgTimestamp) + number of ratings
    @similarityHash = Hash.new(0) #hash that maps a user to a similarity score of another user, similarity = (1 / 1 + ((rating of user1) - (rating of user2).abs))
    @scaleAvgTimestamp = 10000000000 #2 years gives about 6 rating to popularity formula
    @noRating = 6 #the difference between two ratings if a movie is not yet rated by the user
  end
  
  def load_data()
   
     File.readlines('u.data').each do |line|
       
       #user_id- 0, movie_id - 1, rating - 2, timestamp - 3
       dataLine = line.split(" ")
       
       #maps the user hash to a hash of movie_id mapped to the rating given by the user
       @userHash[Integer(dataLine[0])][Integer(dataLine[1])] = (Integer(dataLine[2]))
       
       #maps each movie id to its number of ratings
       @numberOfRatingsHash[Integer(dataLine[1])] = @numberOfRatingsHash[Integer(dataLine[1])] + 1
        
       #puts each movie_id's timestamps into an ARRAY mapped by the movie_id
       @timestampHash[Integer(dataLine[1])] << (Integer(dataLine[3]))
  
     end
     
  end
  
  #takes movie_id (integer) as parameters
  #returns a number determining the popularity
  def popularity(movie_id)     
       
     #gets the average time stamp of a movie_id by getting the timestamp of all ratings and getting the average of that 
     averageTimeStamp = (@timestampHash[movie_id].inject{ |sum, el| sum + el }.to_f / @timestampHash[movie_id].size)
     
     #returns the popularity given by (Average timestamp/ @scaleAvgTimestamp) + number of ratings
     return ((averageTimeStamp  / @scaleAvgTimestamp)) + (@numberOfRatingsHash[movie_id])

      
  end
  
  #returns void
  def popularity_list

       #each key is a movie_id that maps to its average timestamp
       @timestampHash.each do |key, value|
          @avgTimestampHash[key] = (@timestampHash[key].inject{ |sum, el| sum + el }.to_f / @timestampHash[key].size) 
       end
      
       #gets all the popularity of each movie id by the formula (Average timestamp/ @scaleAvgTimestamp) + number of ratings
       @avgTimestampHash.each do |key, value|
          @popularityHash[key] = ((@avgTimestampHash[key]  / @scaleAvgTimestamp)) + (@numberOfRatingsHash[key])
       end
       
       #returns the list of movies from the most popular to the least popular
       return Hash[@popularityHash.sort_by{|k, v| v}.reverse].keys
        
    
  end
  
  #takes two users (integers) as parameters
  #returns an float similaritiy
  def similarity(user1,user2)
    
    similarity = 0
    
    #loops each movie of the first user
    @userHash[user1].each do |key, value|
     
      if(@userHash[user2].has_key?(key)) #check to see if user2 has rated the movie or not
        
        similarity = similarity + (1.0 / (1.0+ ((value - (@userHash[user2][key])).abs))) #if it has then the similarity is given by (1 / 1 + ((rating of user1) - (rating of user2).abs))
        
      else
        
        similarity = similarity + (1.0 / (1.0 + @noRating)) #if the second user has not rated the movie, then the similarity score is given by (1 / 1 + @noRating)
        
      end
      
    end
      
    return similarity
    
  end
  
  #takes a user (integer) as input
  #returns an array of the first ten users who are most similar to the given user
  def most_similar(user)
    
      #look for each user
      @userHash.each do |key,value|
     
        if user != key #do not include the given user
        
        @similarityHash[key] = similarity(user,key) #hash maps user id to its similarity of the given user
        
        end
      
      end
    
    return (Hash[@similarityHash.sort_by {|k,v| v}.reverse]).keys.take(10) #get the first ten users who have the highest similarity score
    
  end
  
end