# ./spec/board_spec.rb

require './lib/board'

RSpec.describe Board do
    subject(:board) { described_class.new }
    
    describe '#place_token' do
      context 'when column is empty' do
        it 'places a token in the bottom slot' do
          board.place_token(1, '⚫')
          expect(board.grid[5][0]).to eq('⚫')
        end
  
        it 'does not place tokens in the entire column' do
          board.place_token(1, '⚫')
          expect(board.grid[4][0]).not_to eq('⚫' || '⚪')
        end
      end
  
      context 'when column has 1 slot filled' do
        it 'places a token in the second-last slot from the bottom' do
          board.place_token(1, '⚪')
          board.place_token(1, '⚪')
          expect(board.grid[4][0]).to eq('⚪')
        end
  
        it 'leaves the third-last slot empty' do
          board.place_token(1, '⚪')
          board.place_token(1, '⚪')
          expect(board.grid[3][0]).not_to eq('⚫' || '⚪')
        end
      end
    end
  
    describe '#game_over' do
      context 'when board is empty' do
        it 'is not game over' do
          expect(board.game_over?('⚫')).to be false
        end
      end
  
      context 'when board is full' do
        before do
          board.instance_variable_set(:@grid, 
           [['⚪', '⚫', '⚫', '⚫', '⚫', '⚫', '⚫'],
            ['⚫', '⚪', '⚪', '⚪', '⚪', '⚪', '⚪'],
            ['⚪', '⚫', '⚫', '⚫', '⚫', '⚫', '⚫'],
            ['⚪', '⚪', '⚪', '⚪', '⚪', '⚪', '⚪'],
            ['⚫', '⚫', '⚫', '⚫', '⚫', '⚫', '⚫'],
            ['⚪', '⚫', '⚪', '⚪', '⚪', '⚪', '⚪']])
        end
  
        it 'is game over' do
          expect(board.game_over?('⚫')).to be true
        end
      end
  
      context 'when there is a vertical win' do
        before do
          board.instance_variable_set(:@grid, 
           [[nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil],
            ['⚪', nil, nil, nil, nil, '⚪', nil],
            ['⚫', nil, nil, nil, nil, '⚪', nil],
            ['⚪', '⚫', nil, nil, nil, '⚪', nil],
            ['⚪', '⚫', '⚫', nil, nil, '⚪', nil]])
        end
  
        it 'is game over' do
          expect(board.game_over?('⚪')).to be true
        end
      end
  
      context 'when there is a horizontal win' do
        before do
          board.instance_variable_set(:@grid, 
           [[nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil],
            ['⚪', nil, nil, nil, nil, nil, nil],
            ['⚫', nil, nil, nil, nil, nil, nil],
            ['⚪', '⚫', nil, nil, nil, nil, nil],
            ['⚪', '⚫', '⚫', '⚫', '⚫', nil, nil]])
        end
  
        it 'is game over' do
          expect(board.game_over?('⚫')).to be true
        end
      end
  
      context 'when there is a diagonal win' do
        before do
          board.instance_variable_set(:@grid, 
           [[nil, '⚫', nil, nil, nil, nil, nil],
            ['⚫', nil, '⚫', nil, nil, nil, nil],
            ['⚪', '⚫', nil, '⚫', nil, nil, nil],
            ['⚫', nil, '⚫', nil, '⚫', nil, nil],
            [nil, '⚫', nil, '⚫', nil, nil, nil],
            ['⚪', '⚫', '⚪', nil, '⚪', nil, nil]])
        end
  
        it 'is game over' do
          expect(board.game_over?('⚫')).to be true
        end
      end
    end
  end