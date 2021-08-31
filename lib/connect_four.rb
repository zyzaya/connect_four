# frozen_string_literal: true

require 'input'

class ConnectFour
  include Input

  def initialize
    @board = empty_board
  end

  def start_game
  end

  def empty_board
    Array.new(7) { Array.new(6) { nil } }
  end

  def end_game(winner, yes, no)
    info = "#{winner} wins! Play again?"
    retry_text = "Invalid input. Enter '#{yes[0]}' or '#{no[0]}'"
    valid = yes + no
    again = get_input(info, retry_text, yes + no)
    start_game if yes.include?(again)
  end
end