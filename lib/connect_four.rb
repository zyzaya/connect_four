# frozen_string_literal: true

require 'input'

class ConnectFour
  include Input

  def initialize
    @board = empty_board
  end

  def start_game(player1, player2)
    board = empty_board
    play_game(board, player1, player2)
  end

  def play_game(board, player1, player2)
    # current_player = player1
    # take_turn
  end

  def empty_board
    Array.new(7) { Array.new(6) { nil } }
  end

  def take_turn(board, player)
    info = "#{player}'s turn. Pick a column."
    retry_text = 'Invalid input. Enter a number between one and seven.'
    valid = available_columns(board)
    column = get_input(info, retry_text, valid)
    update_game_board(board, player, column.to_i)
  end

  def available_columns(board)
    non_full = []
    board.each.with_index do |col, i|
      non_full << (i + 1).to_s if col.any?(&:nil?)
    end
    non_full
  end

  def update_game_board(board, player, column)
    row = board[column].find_index(nil)
    board[column][row] = player unless row.nil?
    board
  end

  def end_game(winner, loser, yes, no)
    info = "#{winner} wins! Play again?"
    retry_text = "Invalid input. Enter '#{yes[0]}' or '#{no[0]}'"
    again = get_input(info, retry_text, yes + no)
    start_game(winner, loser) if yes.include?(again)
  end

  def check_for_winner(board)
    board.each_index do |col|
      board[col].each_index do |row|
        player = board[col][row]
        winner = false
        winner = check_cell_for_winner(board, col, row) unless player.nil?
        return winner if winner
      end
    end
    false
  end

  private

  def check_cell_for_winner(board, col, row)
    offsets = [
      [-1, -1], [0, -1], [1, -1],
      [-1, 0], [1, 0],
      [-1, 1], [0, 1], [1, 1]
    ]
    player = board[col][row]
    offsets.each do |off|
      winner = true
      1.upto(3) do |mult|
        next_col = col + (off[0] * mult)
        next_row = row + (off[1] * mult)
        winner = next_col < board.length && next_row < board[next_col].length
        if winner
          next_cell = board[next_col][next_row]
          winner = player == next_cell
        end
      end
      return player if winner
    end
    false
  end
end
