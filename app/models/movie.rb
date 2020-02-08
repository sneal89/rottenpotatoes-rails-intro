class Movie < ActiveRecord::Base

    def self.ratings
        Movie.select(:rating).distinct.inject([]) { |a, m| a.push m.rating}
    end

    #attr_accessor :title, :rating, :description, :release_date

#def self.ratings
#    ['G', 'PG', 'PG-13', 'R']
#end

  #def self.ratings
  ##  return ['G','PG','PG-13','R']
  #end

end
