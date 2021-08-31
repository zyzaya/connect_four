# frozen_string_literal: true

require 'connect_four'

describe ConnectFour do
  subject(:game) { ConnectFour.new }
  
  describe '#end_game' do
    let(:winner) { 'player1' }
    let(:yes) { %w[yes y] }
    let(:no) { %w[no n] }

    it 'displays winner and asks to replay game' do
      info = "#{winner} wins! Play again?"
      retry_text = "Invalid input. Enter '#{yes[0]}' or '#{no[0]}'"
      valid = yes + no
      expect(game).to receive(:get_input).with(info, retry_text, valid)
      game.end_game(winner, yes, no)
    end

    it 'calls calls #start_game if replaying' do
      allow(game).to receive(:get_input).and_return(yes[0])
      expect(game).to receive(:start_game)
      game.end_game(winner, yes, no)
    end

    it 'does not call #start_game if not replaying' do
      allow(game).to receive(:get_input).and_return(no[0])
      expect(game).not_to receive(:start_game)
      game.end_game(winner, yes, no)
    end
  end

  describe '#empty_board' do
    it 'generates a 2D array with seven columns' do
      result = game.empty_board.length
      expect(result).to eql(7)
    end

    it 'each row is of length six' do
      board = game.empty_board
      result = board.all? { |col| col.length == 6 }
      expect(result).to be_truthy
    end

    it 'has all values as nil' do
      result = game.empty_board.all? { |col| col.all? { |val| val.nil? } }
      expect(result).to be_truthy
    end
  end

  describe '#check_for_winner' do
    let(:board) { game.empty_board }
    let(:player) { 'x' }

    it 'returns false when there is no winner' do
      result = game.check_for_winner(board)
      expect(result).to eql(false)
    end 

    it 'returns the winning player if they win in a row' do
      board[0][1] = player
      board[1][1] = player
      board[2][1] = player
      board[3][1] = player
      result = game.check_for_winner(board)
      expect(result).to eql(player)
    end
   
    it 'returns the winning player if they win in a column' do
      board[1][2] = player
      board[1][3] = player
      board[1][4] = player
      board[1][5] = player
      result = game.check_for_winner(board)
      expect(result).to eql(player)
    end

    it 'returns the winning player if they win diagonaly' do
      board[2][2] = player
      board[3][3] = player
      board[4][4] = player
      board[5][5] = player
      result = game.check_for_winner(board)
      expect(result).to eql(player)
    end
  end
end