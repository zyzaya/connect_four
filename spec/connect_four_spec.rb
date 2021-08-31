# frozen_string_literal: true

require 'connect_four'

describe ConnectFour do
  subject(:game) { ConnectFour.new }
  
  describe '#end_game' do
    let(:winner) { 'player1' }
    let(:loser) { 'player2'}
    let(:yes) { %w[yes y] }
    let(:no) { %w[no n] }

    it 'displays winner and asks to replay game' do
      info = "#{winner} wins! Play again?"
      retry_text = "Invalid input. Enter '#{yes[0]}' or '#{no[0]}'"
      valid = yes + no
      expect(game).to receive(:get_input).with(info, retry_text, valid)
      game.end_game(winner, loser, yes, no)
    end

    it 'calls calls #start_game if replaying' do
      allow(game).to receive(:get_input).and_return(yes[0])
      expect(game).to receive(:start_game)
      game.end_game(winner, loser, yes, no)
    end

    it 'does not call #start_game if not replaying' do
      allow(game).to receive(:get_input).and_return(no[0])
      expect(game).not_to receive(:start_game)
      game.end_game(winner, loser, yes, no)
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

  describe '#take_turn' do
    let(:player) { 'x' }
    let(:board) { game.empty_board }
    let(:valid_input) { [1..7].map(&:to_s) }

    before do
      allow(game).to receive(:available_columns).and_return(valid_input)
      allow(game).to receive(:get_input).and_return('3')
    end

    it 'gets available columns' do
      expect(game).to receive(:available_columns).with(board)
      game.take_turn(board, player)
    end

    it 'calls get_input to get a column from the player' do
      info = "#{player}'s turn. Pick a column."
      retry_text = "Invalid input. Enter a number between one and seven."
      expect(game).to receive(:get_input).with(info, retry_text, valid_input)
      game.take_turn(board, player)
    end

    it 'updates the board with the given columns' do
      expect(game).to receive(:update_game_board).with(board, player, 3)
      game.take_turn(board, player)
    end
  end

  describe '#available_columns' do
    let(:board) { game.empty_board }
    let(:player) { 'x' }

    it 'returns all columns with an empty board' do
      columns = [*1..7].map(&:to_s)
      result = game.available_columns(board)
      expect(result).to eql(columns)
    end

    it 'returns an empty array when the board is full' do
      board.map! do |col|
        col.map { player }
      end
      result = game.available_columns(board)
      expect(result).to eql([])
    end

    it 'returns only non-full columns when some columns are full and some are empty' do
      columns = [*1..7]
      full_columns = [2, 3, 4]
      0.upto(board.length) do |row|
        full_columns.each do |col|
          board[col - 1][row] = player
        end
      end
      non_full_columns = columns - full_columns
      non_full_columns = non_full_columns.map(&:to_s)
      result = game.available_columns(board)
      expect(result).to eql(non_full_columns)
    end
  end

  describe '#update_game_board' do
    let(:board) { game.empty_board }
    let(:player) { 'x' }

    it 'sets the lowest cell to the player in an empty column' do
      column = 4
      changed_board = game.update_game_board(board, player, column)
      result = changed_board[column][0]
      expect(result).to eql(player)
    end

    it 'sets the lowest cell to the player in a partially filled column' do
      column = 3
      changed_board = board
      0.upto(3) { changed_board = game.update_game_board(board, player, column) }
      0.upto(3) do |i|
        result = changed_board[column][i]
        expect(result).to eql(player)
      end
    end

    it 'does nothing if the column is full' do
      column = 5
      changed_board = board
      0.upto(board.length - 1) { changed_board = game.update_game_board(board, player, column) }
      result = game.update_game_board(changed_board, player, column)
      expect(result).to eql(changed_board)
    end
  end

  describe '#start_game' do
    let(:board) { game.empty_board }

    it 'calls #play_game with an empty board' do
      player1 = 'x'
      player2 = 'y'
      expect(game).to receive(:play_game).with(board, player1, player2)
      game.start_game(player1, player2)
    end
  end
end
