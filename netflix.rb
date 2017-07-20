require 'pry'

module MovieProduction

  class Netflix < MovieProduction::MovieCollection
    extend MovieProduction::Cashbox
    attr_reader :balance, :user_filters

    def initialize
      super
      @balance = Money.new(0)
      @user_filters = {}
    end

    def show(params = {}, &block)
      movies = filter(params, &block)
      raise ArgumentError, 'Wrong arguments' unless movies.any?
      movie = pick_movie(movies)
      raise 'Insufficient funds' unless (@balance - movie.price) >= 0
      @balance -= movie.price
      "Now showing: #{movie.title} #{start_end(movie)}"
    end

    def filter(params = {}, &block)
      if block_given?
        select(&block)
      elsif user_filters.keys.include?(params.keys.first) && params.values.first
        block = user_filters[params.keys.first]
        arg = params.values.first
        select do |movie|
          block.call(movie, arg)
        end
      else
        super(params)
      end
    end

    def pay(price)
      raise ArgumentError, 'Wrong amount' unless price > 0
      @balance += Money.new(price*100) # to whole dollars
      Netflix.store_cash(price)
    end

    def how_much?(movie_name)
      raise ArgumentError, 'No such movie' unless filter(title: movie_name).any?
      filter({title: movie_name}).first.price.format
    end

    def define_filter(filter_name, from: nil, arg: nil, &block)
      if from && arg
        user_filters[filter_name] = proc { |m| user_filters[from].call(m, arg) }
      else
        user_filters[filter_name] = block
      end
    end

    private

    def start_end(movie)
      start = Time.now.strftime("%T")
      ending = (Time.now + movie.duration * 60).strftime("%T")
      "#{start} - #{ending}"
    end
  end
end
