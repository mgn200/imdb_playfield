require 'date'
require 'money'

class Movie
  PRICES = { ancient: Money.new(100, 'USD'),
             classic: Money.new(150,'USD'),
             modern: Money.new(300,'USD'),
             new: Money.new(500,'USD')
           }
  attr_reader :list, :link, :title, :year, :country, :date, :genre,
              :duration, :rating, :director, :actors

  def initialize(list, movie_info)
    movie_info.each do |k, v|
      if k == 'year' || k == 'duration'
        self.instance_variable_set "@#{k}", v.to_i
      else
        self.instance_variable_set "@#{k}", v
      end
    end
    @list = list
    @actors = @actors.split ","
    @genre = @genre.split ","
    @date = parse_date(@date)
  end

  def to_s
    "#{@title}, #{@detailed_year}, #{@director}, #{@rating}"
  end

  def month
    Date::MONTHNAMES[@date.mon] unless @date.nil?
  end

  def has_genre?(genre_name)
    raise ArgumentError, 'Invalid genre name' unless @list.has_genre? genre_name
    @genre.any? { |x| genre_name.include? x }
  end

  def matches?(key, value)
    func = send(key)
    if func.is_a? Array
      func.any? { |x| value.include? x }
    else
      value === func
    end
  end

  def price
    PRICES[self.period]
  end

  def period
    self.class.name.match(/(\w+)Movie/)[1].to_s.downcase.to_sym
  end

  private

  def parse_date(date)
    @date = Date.strptime(date, '%Y-%m') if date.length > 4
  end
end
