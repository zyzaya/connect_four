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
end