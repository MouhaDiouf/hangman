require 'tty-prompt'
require 'json'

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


    def save_game 
        game_state = { 
             secret: @@secret, 
             guesses_left: @guesses, 
             user_guess: @user_guess, 
             played: @played 
         }.to_json 
         Dir.mkdir('saved') unless Dir.exist?('saved')
         filename = "saved/game_#{Time.now.to_s}.json"
         File.open(filename, 'w') do |file|
            file.puts game_state
          end

     end 
  

     def load_game
         
     end 

    def start 
        choose_word
        puts "Welcome to the hangman game! You have #{@guesses} chances to guess the secret word chosen by the Computer"
        puts  '_' * @@secret.length
        until @user_guess.join == @@secret || @guesses == 0
            prompt = TTY::Prompt.new
            greeting = 'Do you like to keep playing or reload a previous game?'
            choices = ['Keep Playing' ,'Save & Quit']
            answer = prompt.select(greeting, choices)
            if answer == choices[0]
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
            else
                save_game
                exit
            end 

        end
        check_game_over
        
        
    end #end of start method 

  
    def check_game_over 
        if @guesses > 0 
            puts "You win! 🎉🎉"
        else
            puts "Game over :(. It ways #{@@secret}" 
        end 
        exit
    end 

  
    
end 


prompt = TTY::Prompt.new
greeting = 'Do you like to play a new game or reload a previous one?'
choices = ['New Game' ,'Previous One']
answer = prompt.select(greeting, choices)
if answer == choices[0]
    game = Game.new 
    game.start
else


end 

