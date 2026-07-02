class GamesController < ApplicationController
require "json"
require "open-uri"

  def new
    @letters = []
    10.times do
      single = ("a".."z").to_a.sample
      @letters << single
    end
  end

  def score
    create_score
    @word = params[:word]
    @batch = params[:letters]

    @resultsMessage = "Congratulations! #{@word} is a valid word!"
    @score = @word.length * (@word.length - 1)

    if check_word_online?(@word) == false
      @resultsMessage = "Nuh-uh, '#{@word}' isn't a real word (according to us, anyway)."
      @score = 0
    elsif check_if_valid?(@word) == false
      @resultsMessage = "Sorry, '#{@word}' doesn't seem to match the batch of '#{@batch}.'"
      @score = 0
    else session[:global_score] += @score
    end
  end

  private

  def check_if_valid?(word)
    passed = true
    word.downcase.chars.tally.each do |letter, total|
      if @batch.gsub(" ", "").chars.tally[letter].nil? || @batch.gsub(" ", "").chars.tally[letter] < total
        passed = false
        return passed
      end
    end
    passed
  end

  def check_word_online?(word)
    url = "https://dictionary.lewagon.com/"

    word_serialized = URI.open("#{url}#{word}").read
    word_searched = JSON.parse(word_serialized)
    word_searched["found"]
  end

  def create_score
    session[:global_score] = 0 unless session[:global_score]
  end
end
