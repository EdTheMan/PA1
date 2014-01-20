require_relative 'rating'

class MovieData
  
  def initialize
    @userHash = Hash.new {|h,k| h[k] = Hash.new }
    @numberOfRatingsHash = Hash.new(0)
    @timestampHash = Hash.new {|h,k| h[k] = Array.new }
    @avgTimestampHash = Hash.new
    @popularityHash = Hash.new
    @similarityHash = Hash.new(0)
    @scaleAvgTimestamp = 10000000000 #2 years gives about 6 rating 
    @noRating = 6
    
    
  end
  
  def load_data()

   
     File.open('C:\Users\Eddie\Desktop\cosi 236b\ml-100k\u.data').read.each_line do |line|
       
       #user_id- 0, movie_id - 1, rating - 2, timestamp - 3
       dataLine = line.split(" ")
       
       #maps user_id to an array of movie_ids (index 0) and an array of ratings (index 1)
       @userHash[Integer(dataLine[0])][Integer(dataLine[1])] = (Integer(dataLine[2]))
       #(@userHash[Integer(dataLine[0])][1] ||= [] ) << (Integer(dataLine[2]))
       
       
       #maps each movie id to its number of ratings
       @numberOfRatingsHash[Integer(dataLine[1])] = @numberOfRatingsHash[Integer(dataLine[1])] + 1
        
       #puts each movie_id's timestamps into an ARRAY mapped by the movie_id
       @timestampHash[Integer(dataLine[1])] << (Integer(dataLine[3]))
     
       
     end
     
    
    

    
     
  end
  
  def test()
 
  p similarity(196,22)
  
  end
  
  def popularity(movie_id)     
     
     if @popularityHash[movie_id].nil?
       
     averageTimeStamp = (@timestampHash[movie_id].inject{ |sum, el| sum + el }.to_f / @timestampHash[movie_id].size)
     
     return ((averageTimeStamp  / @scaleAvgTimestamp)) + (@numberOfRatingsHash[movie_id])
     
     else
       
       return @popularityHash[movie_id]
       
     end
      
  end
  
  def popularity_list


       #each key is a movie_id that maps to its average timestamp
       @timestampHash.each do |key, value|
          @avgTimestampHash[key] = (@timestampHash[key].inject{ |sum, el| sum + el }.to_f / @timestampHash[key].size) 
       end
      
       #gets all the popularity of each movie id by the formula average timestamp/ 100000000 + number of ratings
       @avgTimestampHash.each do |key, value|
          @popularityHash[key] = ((@avgTimestampHash[key]  / @scaleAvgTimestamp)) + (@numberOfRatingsHash[key])
       end
       
       return Hash[@popularityHash.sort_by{|k, v| v}.reverse].keys
        
    
  end
  
  
  def similarity(user1,user2)
    
    similarity = 0
    
    #movie is at index 0 and ratings is at index 1 for the specific movie
    @userHash[user1].each do |key, value|
      
      if(@userHash[user2].has_key?(key))
        
        similarity = similarity + (1.0 / (1.0+ ((value - (@userHash[user2][key])).abs)))
        
      else
        
        similarity = similarity + (1.0 / (1.0 + @noRating))
        
      end
      
    end
      
    return similarity
    
  end
  
  def most_similar(user)
    
      @userHash.each do |key,value|
      
        if user != key
        
        @similarityHash[key] = similarity(user,key)
        
        end
      
      end
    
    return (Hash[@similarityHash.sort_by {|k,v| v}.reverse].keys.take(10))
    

    
  end
   
  
end