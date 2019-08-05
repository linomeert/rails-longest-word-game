require 'open-uri'

class GamesController < ApplicationController
  all_letters = [('A'..'Z')].map(&:to_a).flatten
  GRID = (0...10).map { all_letters[rand(all_letters.length)] }


  def index
    session[:score] = nil
  end

  def new
    @grid = GRID
  end

  def score
    @try = params[:word].upcase
    @score = session[:score]
    @score = 0
    @grid = GRID
    @grid_string = @grid.join(",")
    url = "https://wagon-dictionary.herokuapp.com/#{@try}"
    user_serialized = open(url).read
    word = JSON.parse(user_serialized)

    try_split = @try.split("")
    match_letters = @grid.select{|char| try_split.include?(char)}
    sorted_match = match_letters.sort
    sorted_attempt = try_split.sort

    if sorted_match == sorted_attempt && word["found"] == true
      @answer = "Good job! #{@try} can be built out of #{@grid_string}"
      @score += sorted_attempt.size
    elsif word["found"] == false
      @answer = "Sorry but #{@try} is not a valid word"
    else
      @answer = "Sorry but #{@try} can't be built out of #{@grid_string}"
    end
  end
end
