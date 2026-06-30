class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      single = ("a".."z").to_a.sample
      @letters << single
    end
  end

  def score
  end
end
