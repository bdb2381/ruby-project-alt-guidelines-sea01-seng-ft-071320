require 'colorize'
class CLI

    def welcome 
        system "clear"
        puts render_ascii_art
        sleep 5
        login_menu
    end

    def render_ascii_art
        File.readlines("ascii.txt") do |line|
            puts line
        end
    end
    
    def render_banner
        puts "\n\n"
        puts '                            __                       ___       __              __                   '.red. bold                                                  
        puts '     ____ _____  ____  ____/ /  _________  ____     /__ \     / /_  ____ _____/ /  _________  ____  '.red.bold
        puts '    / __ `/ __ \/ __ \/ __  /  / ___/ __ \/ __ \     / _/    / __ \/ __ `/ __  /  / ___/ __ \/ __ \ '.red.bold
        puts '   / /_/ / /_/ / /_/ / /_/ /  / /__/ /_/ / /_/ /    /_/     / /_/ / /_/ / /_/ /  / /__/ /_/ / /_/ / '.blue.bold
        puts '   \__, /\____/\____/\__,_/   \___/\____/ .___/    (_)     /_.___/\__,_/\__,_/   \___/\____/ .___/ '.blue.bold
        puts "   ____/                               /_/                                                /_/      \n\n".blue.bold
        # puts '  *************************************************************************************************'.bold
        # puts '  *************************************************************************************************'.bold
        puts '  *************************************************************************************************'.bold
    end
    
    def render_exit
        File.readlines("exit.txt") do |line|
            puts line
        end
    end

    def login_menu
        system "clear"
        puts render_banner

        puts "To get started, please enter a username:".blue.bold
        username = gets.chomp.downcase.titleize
        puts "Please enter a location:".blue.bold
        location = gets.chomp.downcase.titleize 
        
        user_instance = User.find_by(username: username, location: location)
        
        if user_instance
            puts "Welcome back looks like you already have an acount with us, lets take you to the Main Menu"    
        else
            gender = gender_menu
            race = demographic_menu
            user_instance = User.create(username: username, location: location, race: race, gender: gender)
            puts "Thanks for setting up an account."    
        end
        sleep 2
        main_menu(user_instance)
    end 

    def gender_menu
        prompt = TTY::Prompt.new(active_color: :red)
        choices = {"M" => 1, "F" => 2, "Other" => 3, "Prefer not to answer" => 4}
        gender = prompt.select("Select", choices, cycle: true, echo: false, filter: true)  
    end

    def demographic_menu
        prompt = TTY::Prompt.new(active_color: :red)
        choices = {"Black" => 1, "White" => 2, "Asian" => 3, "Hispanic" => 4, "Other" => 5, "Prefer not to answer" => 6}
        race = prompt.select("What is your race?", choices, cycle: true, echo: false, filter: true) 
    end

    def get_officer_instance
        Officer.all.collect{|officer| officer.officer_name} 
    end

    def are_you_sure(user_instance)
        prompt = TTY::Prompt.new(active_color: :red)
        menu_choice = prompt.select("",cycle: true, echo: false) do |menu| sleep 1
            menu.choice 'Yes'
            menu.choice 'No',-> {main_menu(user_instance)}
        end
    end
      
    def exit
        system "clear"
        puts render_exit
        sleep 3.5
        system "clear"
        exit!
    end
    
    def main_menu(user_instance)

        system "clear"
        puts render_banner
        prompt = TTY::Prompt.new(active_color: :red)
        menu_choice = prompt.select("Please select from the folowing options".blue.bold + " #{user_instance.username}".red.bold, cycle: true, echo: false) do |menu| 
            menu.choice 'Rate an officer',-> {rate_officer(user_instance)}
            menu.choice 'View officer average rating',-> {get_average_rating(user_instance)}
            menu.choice 'Change a previous review',-> {change_rating(user_instance)}
            menu.choice 'Delete previous review',-> {delete_review(user_instance)}
            menu.choice 'Exit',-> {exit}
        end
    end
        
    def rate_officer(user_instance)
        system "clear"
        puts render_banner
        
        prompt = TTY::Prompt.new(active_color: :red)
        
        officer_choices = get_officer_instance
        officer = prompt.select("Choose an officer to rate:".blue.bold, officer_choices, cycle: true , echo: false, filter: true).chomp
        @officer_instance = Officer.find_by(officer_name: officer)
        sleep 1
        
        puts "You chose:" + " #{@officer_instance.officer_name}".red.bold  
        puts "Please rate your interaction with the Officer.".blue.bold
        rating = prompt.slider("Rating", max: 10, step: 0.5, default: 0, format: "|:slider| %.1f")
        
        puts "Please include a description of your interaction with".blue.bold + " #{@officer_instance.officer_name}".red.bold + ":".blue.bold
        review_desc = gets.chomp 

        puts "Are you sure you want to submit this review?".blue.bold
        are_you_sure(user_instance)

        @review_instance = Review.create(user: user_instance, officer: @officer_instance, rating: rating, review_desc: review_desc)
        sleep 1
        
        puts "Thank you" + " #{user_instance.username}".red.bold + " for your review of" + " #{@officer_instance.rank}".red.bold + " #{@officer_instance.officer_name}".red.bold + "."
        puts "Who works in" + " #{@officer_instance.preicient}".red.bold + ", badge number" + " #{@officer_instance.badge_number}".red.bold 
        puts "You have given them a review of:" + "#{rating}/10".red.bold + " and a description of:" + " #{review_desc}".red.bold
        
        go_back_or_repeat("Do you want to submit another rating?", user_instance)
    end
    
    def go_back_or_repeat(prompt_question, user_instance)
        prompt = TTY::Prompt.new(active_color: :red)
    
        prompt.select(prompt_question.blue.bold, cycle: true, echo: false) do |menu| sleep 1
            if prompt_question == "View more average ratings?"
                menu.choice 'Yes',-> {get_average_rating(user_instance)} 
                menu.choice 'Back to Main Menu',-> {main_menu(user_instance)}
            elsif prompt_question == "Do you want to update another review?"
                menu.choice 'Yes',-> {change_rating(user_instance)} 
                menu.choice 'Back to Main Menu',-> {main_menu(user_instance)}
            elsif prompt_question == "Do you want to delete another review?"
                menu.choice 'Yes',-> {delete_review(user_instance)} 
                menu.choice 'Back to Main Menu',-> {main_menu(user_instance)}
            elsif prompt_question == "Do you want to submit another rating?"
                menu.choice 'Yes',-> {rate_officer(user_instance)} 
                menu.choice 'Back to Main Menu',-> {main_menu(user_instance)}
                
            end
        end    
    end
    
    def get_average_rating  (user_instance)
        system "clear"
        puts render_banner
        prompt = TTY::Prompt.new(active_color: :red)
        
        officer_choices = get_officer_instance
        officer = prompt.select("Choose an officer to veiw their average rating:".blue.bold, officer_choices, cycle: true , echo: false, filter: true)
        
        @officer_instance = Officer.find_by(officer_name: officer)
        officer_review_selection = Review.all.select {|review| review.officer_id == @officer_instance.id}

        total_reviews = officer_review_selection.map {|review| review.rating}
        avg_rating = total_reviews.sum / total_reviews.length

        puts "Officer" + " #{@officer_instance.officer_name}".red.bold + " has a average rating of" + " #{avg_rating}.".red.bold + " and a description of:" + " #{review_desc}".red.bold

        sleep 1
        go_back_or_repeat("View more average ratings?",user_instance)

        
        
        
    end

    
    def change_rating(user_instance)
        system "clear"
        puts render_banner
        prompt = TTY::Prompt.new(active_color: :red)

        user_reviews = Review.find_by(user_id: user_instance)
    
        if user_reviews
            reviews = Review.all.select {|review| review.user_id == user_instance.id}
            officer_names = reviews.map {|review| review.officer.officer_name}

            officer_selection =  prompt.select("Please select your review to update:".blue.bold, officer_names, cycle: true , echo: false, filter: true)
            
            officer_review = reviews.select {|review| review.officer.officer_name == officer_selection}
            officer_x = Officer.find_by(officer_name: officer_selection)

            puts "Please update your rating for:".blue.bold + " #{officer_selection}".red.bold
            rating = prompt.slider("Rating", max: 10, step: 0.5, default: 0, format: "|:slider| %.1f")
            sleep 1
            
            puts "Please include a description of your interaction with:".blue.bold + " #{officer_x.rank} #{officer_x.officer_name}".red.bold
            review_desc = gets.chomp
            
            review_id = officer_review.map {|review| review.id}

            puts "Are you sure you want to submit this updated review?".blue.bold
            are_you_sure(user_instance)
            
            Review.update(review_id[0], rating: rating, review_desc: review_desc)
            
            puts "You have updated your review of:".blue.bold + " #{officer_selection}".red.bold + " to".blue.bold + " #{rating}".red.bold
        else
            puts "It looks like you have not made any reviews yet. Lets take you back to the main menu."
        end
        
        sleep 1
        go_back_or_repeat("Do you want to update another review?", user_instance)

        
    end
    

    def delete_review(user_instance)
        system "clear"
        puts render_banner
        prompt = TTY::Prompt.new(active_color: :red)

        user_reviews = Review.find_by(user_id: user_instance)
        if user_reviews
            reviews = Review.all.select {|review| review.user_id == user_instance.id} #selecting all reviews of officers that match reviews by user
            officer_names = reviews.map {|review| review.officer.officer_name} #return names as array of strings
            officer =  prompt.select("Please select a review to delete:".blue.bold, officer_names, cycle: true , echo: false, filter: true)#tty menu
            
            
            officer_review = reviews.select {|review| review.officer.officer_name == officer} #returns review instance associated with the name entered above
            officer_x = Officer.find_by(officer_name: officer) #matching officer instance
            review_id = officer_review.map {|review| review.id} #finds id for review instance
            
            puts "Are you sure you want to delete this review?".blue.bold
            are_you_sure(user_instance)

            Review.destroy(review_id[0]) #deletes review.    
            puts "You have deleted your rating of:" " #{officer}".red.bold
        else
            puts "You do not have any reviews to delete. Lets take you back to the main menu."
        end
        
        sleep 1

        go_back_or_repeat("Do you want to delete another review?", user_instance)  
        
        
        
    end

end #END OF CLASS




