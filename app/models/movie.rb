class Movie < ActiveRecord::Base

    #attr_accessor :title, :rating, :description, :release_date

#def self.ratings
#    ['G', 'PG', 'PG-13', 'R']
#end

  def self.ratings
    return ['G','PG','PG-13','R']
  end

end
