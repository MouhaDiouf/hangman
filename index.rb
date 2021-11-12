
class Game 
    @@file = File.read('dictionary.txt').split
    def initialize 
        @@secret =  nil 
        @guesses =  nil 
        @user_guess = nil 
        @played = []
    end

    def choose_word 
        file = File.read('dictionary.txt').split
        @@secret = file[rand(0...file.length)]
        @guesses = @@secret.length + 3
        
        while (@@secret.length < 5 || @@secret.length > 12)
            @@secret = file[rand(0...file.length)]
        end 
        @user_guess = Array.new(@@secret.length).fill('_')
    end 

    def start 
        choose_word
        puts "Welcome to the hangman game! You have #{@guesses} chances to guess the secret word chosen by the Computer"
        puts  '_' * @@secret.length
        until @user_guess.join == @@secret || @guesses == 0
            puts "Make a guess (one letter at a time) from a-z (uppercased included)"
            letter_input = gets.chomp
            if @played.include? letter_input
                puts "This is already played. Try again"
                next
            elsif  @@secret.include?(letter_input)
                @@secret.split('').each_with_index do |chr, idx|
                    if letter_input == chr 
                        @user_guess[idx] = chr 
                    end 
                end 
            end
            @guesses -= 1
            puts "#{@guesses} guesses left"
            @played << letter_input 
            puts @user_guess.join
        end
        
        check_game_over
        
    end 

    def check_game_over 
        if @guesses > 0 
            puts "You win! 🎉🎉"
        else
            puts "Game over :(. It ways #{@@secret}" 
        end 
    end 
    
end 



game = Game.new 
game.start