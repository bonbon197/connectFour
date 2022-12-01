# ./lib/players.rb

class HumanPlayer
    attr_accessor :name, :mark
    
    def initialize(name, mark)
        @name = name
        @mark = mark
    end
end

class CPUPlayer < HumanPlayer
    def random_move
        rand(1..7)
    end
end