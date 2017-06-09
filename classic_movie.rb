require 'pry'

class ClassicMovie < Movie
  attr_reader :list

  def initialize(list, movie_info)
    super(list, movie_info)
  end

  def to_s
    movies = list.filter(director: @director).map(&:title).join(",")
    "#{@title} - классический фильм, режиссёр #{@director}(#{movies})"
  end
end
