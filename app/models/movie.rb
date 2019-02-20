class Movie < ActiveRecord::Base
    def self.all_ratings
        ['G', 'PG', 'PG-13', 'R']
    end
    
    # filter according to the rating
    def self.ratings_filter(rating)
      @rating = rating
          self.where(rating: @rating.keys)
    end
    
    # sort title
    def self.sort_on(section, movies)
      @sort = section
      @movies = movies
      if @sort == "title"
          @movies = @movies.sort do |a,b|
              a.title <=> b.title
          end
      elsif @sort == "release_date"
          @movies = @movies.sort do |a,b|
              a.release_date <=> b.release_date
          end
      end
    end
    
end