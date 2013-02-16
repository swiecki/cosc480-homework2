class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
  def self.ratings
    Movie.uniq.pluck(:rating)
  end
  def self.hratings
    a = Movie.ratings
    Hash[a.map {|v| [v,1]}]
  end
end
