class CLI
    def welcome
        puts "Welcome to (APP NAME)"
        login_menu
    end

    def login_menu
        puts "To get started, please enter a username:"
        username = gets.chomp.downcase.titleize
        puts "Please enter a location"
        location = gets.chomp.downcase.titleize #how do you make the second word capitolized?
        check = User.find_by(username: username, location: location)
        if check
            puts "Welcome back  looks like you already have an acount with us, lets take you to the main menu"
        else
            gender = gender_menu
            race = demographic_menu
            User.create(username: username, location: location, race: race, gender: gender)
            puts "thanks for setting up a account!"
        end
        main_menu(username)
    end 


    def gender_menu
        prompt = TTY::Prompt.new
        gender = prompt.select("What is your gender?", cycle: true, echo: false, filter: true) do |menu| sleep 1
            menu.choice 'F'
            menu.choice 'M'
            # demographic
        end
    end

    def demographic_menu
        prompt = TTY::Prompt.new
        race = prompt.select("What is your gender?", cycle: true, echo: false, filter: true) do |menu| sleep 1
            menu.choice 'Black'
            menu.choice 'White'
            menu.choice 'Asian'
            menu.choice 'Hispanic'
            menu.choice 'Other'   #option to add in a write in your own via TTY?


            
            puts "kldjsfjkldsafjkl"
        end
    end
    

    def main_menu(username)
        prompt = TTY::Prompt.new
        menu_choice = prompt.select("Please select from the folowing options #{username}", cycle: true, echo: false) do |menu| sleep 1
            menu.choice 'Rate an officer'
            menu.choice 'View officer average rating'
            menu.choice 'Change your rating'
            menu.choice 'Delete previous review'
            # menu.choice 'Delete last rating'
            menu.choice 'Exit'
        end

        if menu_choice == 'Rate an officer.'
            rate_officer
        elsif menu_choice == 'View officer average rating'
            get_average_rating
        elsif menu_choice == 'Change your rating'
            change_rating
        elsif menu_choice == 'Delete previous review'
            delete_review
        #   elsif welcome == 'Delete last rating'
            # delete_rating

        else 
            puts "Thanks for stopping by!"
        end
    end

    def rate_officer
        binding.pry
    end

    def get_average_rating

    end

    def change_rating

    end

    def delete_review
        
    end

end