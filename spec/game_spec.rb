# spec/game_spec.rb
require './lib/game'

RSpec.describe Game do
    subject(:game) { described_class.new }
    let(:player1) { double(HumanPlayer, name: 'P1', mark: '⚫') }
    let(:cpuPlayer) {double(CPUPlayer, name: 'CPU', mark: '⚫')}
    let(:board) { double(Board) }
  
    describe '#create_player' do
      context 'when creating player 1' do
        before do
          allow(game).to receive(:puts)
          allow(game).to receive(:gets).and_return('P1')
        end
  
        it 'create Human Player 1' do
          expect(HumanPlayer).to receive(:new).with('P1', '⚫')
          game.create_player(1)
        end
      end
  
      context 'when creating player 2' do
        before do
          allow(game).to receive(:puts)
          allow(game).to receive(:gets).and_return('P2')
        end
  
        it 'create Human Player 2' do
          expect(HumanPlayer).to receive(:new).with('P2', '⚪')
          game.create_player(2)
        end
      end

      context 'when creating AI/CPU Player' do
        before do
          allow(game).to receive(:puts)
          allow(game).to receive(:gets).and_return('CPU')
        end

        it 'create AI Player' do
          expect(CPUPlayer).to receive(:new).with('Cpu', '⚫')
          game.create_player(1)
        end
      end
    end
  
    describe '#solicit_move' do
      context 'when given a valid move' do
        before do
          allow(game).to receive(:gets).and_return('1\n')
        end
  
        it 'stop loop, do not display error message' do
          error_message = 'Invalid input, please choose an empty column between 1 and 7.'
          expect(game).not_to receive(:puts).with(error_message)
          game.solicit_move
        end
      end
  
      context 'invalid move, then valid move' do
        before do
          letter = 'a'
          valid_input = '3'
          allow(game).to receive(:gets).and_return(letter, valid_input)
        end
  
        it 'complete loop, display error once' do
          error_message = 'Invalid input, please choose an empty column between 1 and 7.'
          expect(game).to receive(:puts).with(error_message).once
          game.solicit_move
        end
      end
  
      context 'two times invalid move, then one valid' do
        before do
          letter = 'a'
          large_num = '100'
          valid_input = '1'
          allow(game).to receive(:gets).and_return(letter, large_num, valid_input)
        end
  
        it 'complete loop, display error twice' do
          error_message = 'Invalid input, please choose an empty column between 1 and 7.'
          expect(game).to receive(:puts).with(error_message).twice
          game.solicit_move
        end
      end
    end
  
    describe '#play_game' do
      context 'when #board.game_over? is false four times' do
        before do
          allow(game).to receive(:setup)
          allow(game).to receive(:current_player).and_return(player1)
          allow(game.board).to receive(:game_over?).with(player1.mark).and_return(false, false, false, false, true)
        end
  
        it 'calls #switch_turns four times' do
          allow(game).to receive(:play_round)
          expect(game).to receive(:switch_turns).exactly(4).times
          game.play_game
        end
  
        it 'calls #play_round four times' do
          expect(game).to receive(:play_round).exactly(4).times
          game.play_game
        end
  
        it 'calls #conclusion once' do
          allow(game).to receive(:play_round)
          expect(game).to receive(:conclusion).once
          game.play_game
        end
      end
    end
  
    describe '#play_round' do
      before do
        allow(game).to receive(:prompt_player)
        allow(game).to receive(:current_player).and_return(player1)
        allow(game).to receive(:solicit_move).and_return(1)
      end
  
      it 'sends #place_token to board' do
        allow(game.board).to receive(:display)
        expect(game.board).to receive(:place_token).with(1, '⚫')
        game.play_round
      end
  
      it 'sends #display to board' do
        expect(game.board).to receive(:display)
        game.play_round
      end
    end
  end