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
    @similarityHash = Hash.new(0)
    
  end
  
  def load_data()

   
     File.open('C:\Users\Eddie\Desktop\cosi 236b\ml-100k\u.data').read.each_line do |line|
       
       #user_id- 0, movie_id - 1, rating - 2, timestamp - 3
       dataLine = line.split(" ")
       
       #maps user_id to an array of movie_ids (index 0) and an array of ratings (index 1)
       (@moviesHash[Integer(dataLine[0])][0] ||= [] ) << (Integer(dataLine[1]))
       (@moviesHash[Integer(dataLine[0])][1] ||= [] ) << (Integer(dataLine[2]))
       
       #maps each movie id to its number of ratings
       @numberOfRatingsHash[Integer(dataLine[1])] = @numberOfRatingsHash[Integer(dataLine[1])] + 1
        
       #puts each movie_id's timestamps into an ARRAY mapped by the movie_id
       @timestampHash[Integer(dataLine[1])] << (Integer(dataLine[3]))
     
       
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
  
  def test()
  
  
    p similarity(196,244)

    #@moviesHash.keys[0..10].each { |key| puts "#{key} => #{@moviesHash[key]}" }
    #p @moviesHash[196][0]
  
  end
  
  def popularity(movie_id)     
     
     #p "Number of Ratings - #{@numberOfRatingsHash[movie_id]}"
     #p ""
     #p "Average time - #{@avgTimestampHash[movie_id]}"
     #p ""
     p "Popularity - #{@popularityHash[movie_id]}"
     #p ""
      

  end
  
  def popularity_list

    p (Hash[@popularityHash.sort_by{|k, v| v}.reverse])
    
  end
  
  
  def similarity(user1,user2)
    
    similarity = 0
    
    #movie is at index 0 and ratings is at index 1 for the specific movie
    @moviesHash[user1][0].each_with_index do |value,index|
      
      if(@moviesHash[user2][0].include?(value))
        
        similarity += (1.0 / (1.0+ ( \
        ( \
         (@moviesHash[user1][1][index]) \
        - \
         (@moviesHash[user2][1][@moviesHash[user2][0].index(value)]) \
         ) \
         .abs)))
        
      else
        
        similarity += + (1.0 / (1.0 + @noRating))
        
      end
      
    end
      
    return similarity
    
  end
  
  def most_similar(user)
    
      @moviesHash.each do |key,value|
      
        if user != key
        
        @similarityHash[key] = similarity(user,key)
        
        end
      
      
      end
    
      a = @similarityHash.sort_by {|k,v| v}.reverse
      
      b = Array.new
      
      for x in 0..9
      
        b << a[x].first
      
      end
      
    return (b.take(10))
    

    
    
  end
   
  
end