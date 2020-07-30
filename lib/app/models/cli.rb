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

    def login 
        prompt = new_prompt
        
        
        puts "Please enter your username:".blue.bold
        username = gets.chomp.downcase.titleize
        puts "\n"
        
        password = prompt.mask("Enter your password".blue.bold) 
        user_instance = User.find_by(username: username, password: password)
        
        if user_instance
            puts "\n"
            puts "Welcome back looks like you already have an acount with us, lets take you to the Main Menu"  
            sleep 3
            main_menu(user_instance)
        else
            puts "\n"
            puts "Looks like you don't have an account set up with us, let's get you started"
            sleep 3
            sign_up
        end
    end
    


    def sign_up
        # prompt = new_prompt
        system "clear"
        puts render_banner

        prompt = TTY::Prompt.new(active_color: :red)
        menu_choice = prompt.select("Are you sure you want to create a new account?",cycle: true, echo: false) do |menu|
            # prompt_question == "Are you sure you want to create a new account?"
            menu.choice 'Yes'  
            menu.choice 'No, go back to Main Menu',-> {login_menu}
        end

        puts "\n"
        
        puts "Let's get your account set up!".bold.blue
        puts "\n"
        username = create_username
        puts "\n"
        password = create_password
        puts "\n"
        location = location_menu
        puts "\n"
        race = demographic_menu
        puts "\n"
        gender = gender_menu
        puts "\n"
        user_instance = User.create(username: username, password: password, location: location, race: race, gender: gender)
        
        puts "Thanks for setting up an account." 
        sleep 3
        main_menu(user_instance)
    end
    
    def login_menu
        
        puts "Welcome to Good Cop ? Bad Cop".blue.bold
        prompt = new_prompt
        # prompt = TTY::Prompt.new(active_color: :red)
        menu_choice = prompt.select("",cycle: true, echo: false) do |menu|
            menu.choice 'Login',-> {login}
            menu.choice 'Sign Up',-> {sign_up}
        end
    end
       
    def location_menu
        puts "Please enter your location:".blue.bold
        location = gets.chomp
    end

    def create_username
        puts "Please create a username:".blue.bold
        username = gets.chomp.downcase.titleize
        
        # if User.exists?(username)
        #     puts "Looks like #{username} is taken."
        #     sleep 3
        #     create_username
        # end
    end
    
    
    def create_password
        prompt = TTY::Prompt.new(active_color: :red)
        password = prompt.mask("Please create a password:".blue.bold) 
    end
    
    def gender_menu
        prompt = TTY::Prompt.new(active_color: :red)
        choices = {"M" => "M", "F" => "F", "Other" => "Other", "Prefer not to answer" => "Prefer not to answer"}
        gender = prompt.select("Select your gender:".blue.bold, choices, cycle: true, echo: false, filter: true)  
    end

    def demographic_menu
        prompt = TTY::Prompt.new(active_color: :red)
        choices = {"Black" => "Black", "White" => "White", "Asian" => "Asian", "Hispanic" => "Hispanic", "Other" => "Other", "Prefer not to answer" => "Prefer not to answer"}
        race = prompt.select("What is your race ?".blue.bold, choices, cycle: true, echo: false, filter: true) 
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

        prompt = new_prompt
        menu_choice = prompt.select("Please select from the folowing options,".blue.bold + " #{user_instance.username}".red.bold + ":".blue.bold, cycle: true, echo: false, per_page: 7) do |menu| 
            menu.choice 'Rate an officer',-> {rate_officer(user_instance)}
            menu.choice 'View officer average rating',-> {get_average_rating(user_instance)}
            menu.choice 'Change a previous review',-> {change_rating(user_instance)}
            menu.choice 'Delete previous review',-> {delete_review(user_instance)}
            menu.choice 'Logout',-> {login_menu}
            menu.choice 'View your profile',-> {view_profile(user_instance)}
            menu.choice 'Exit',-> {exit}
        end
    end
        
    def view_profile(user_instance)
        prompt = new_prompt
        # binding.pry
        puts "Username:"
        puts "#{user_instance.username}\n".red.bold
        puts "Gender:"
        puts "#{user_instance.gender}\n".red.bold
        puts "Race:"
        puts "#{user_instance.race}\n".red.bold
        puts "Location:"
        puts "#{user_instance.location}\n".red.bold
        puts "\n"
    
     
        reviews = Review.all.select {|review| review.user_id == user_instance.id}
        
        if reviews == []
            puts "Looks like you don't have any reviews at this time."
        else
            officer_names = reviews.map {|review| review.officer.officer_name}

            officer_selection =  prompt.select("These are your reviewed officers:".blue.bold, officer_names, cycle: true , echo: false, filter: true, per_page: 8)
            
            officer_review = reviews.select {|review| review.officer.officer_name == officer_selection}
            officer_x = Officer.find_by(officer_name: officer_selection)
            
        end
        go_back_or_repeat("", user_instance)
    end

    def rate_officer(user_instance)
        prompt = new_prompt
        
        officer_choices = get_officer_instance
        officer = prompt.select("Choose an officer to rate:".blue.bold, officer_choices, cycle: true , echo: false, filter: true).chomp
        @officer_instance = Officer.find_by(officer_name: officer)
        sleep 1
        
        puts "\n"
        puts "You chose:" + " #{@officer_instance.officer_name}".red.bold  
        puts "Please rate your interaction with the Officer:".blue.bold
        
        puts "\n"
        rating = prompt.slider("Rating", max: 10, step: 0.5, default: 0, format: "|:slider| %.1f")
        puts "\n"
        puts "Please include a description of your interaction with".blue.bold + " #{@officer_instance.officer_name}".red.bold + ":".blue.bold
        review_desc = gets.chomp 
        
        puts "\n"
        puts "Are you sure you want to submit this review?".blue.bold
        are_you_sure(user_instance)

        @review_instance = Review.create(user: user_instance, officer: @officer_instance, rating: rating, review_desc: review_desc)
        sleep 1
        puts "\n"
        puts "Thank you" + " #{user_instance.username}".red.bold + " for your review of" + " #{@officer_instance.rank}".red.bold + " #{@officer_instance.officer_name}".red.bold + "."
        puts "Works out of:" + " #{@officer_instance.preicient}".red.bold + " Badge Number:" + " #{@officer_instance.badge_number}".red.bold 
        puts "You have given them a review of:" + " #{rating}/10".red.bold + " and a description of:" + " #{review_desc}".red.bold
        
        go_back_or_repeat("Do you want to submit another rating?", user_instance)
    end
    
    def go_back_or_repeat(prompt_question, user_instance)
        prompt = TTY::Prompt.new(active_color: :red)
        puts "\n"
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
            elsif prompt_question == ""
                menu.choice 'Back to Main Menu',-> {main_menu(user_instance)}
            end

        end    
    end
    
    def get_average_rating  (user_instance)
        prompt = new_prompt
        
        officer_choices = get_officer_instance
        officer = prompt.select("Choose an officer to veiw their average rating:".blue.bold, officer_choices, cycle: true , echo: false, filter: true)
        puts "\n"
        
        @officer_instance = Officer.find_by(officer_name: officer)
        officer_review_selection = Review.all.select {|review| review.officer_id == @officer_instance.id}
        
        total_reviews = officer_review_selection.map {|review| review.rating}
        avg_rating = total_reviews.sum / total_reviews.length
   
        # User.where(["name = :name and email = :email", { name: "Joe", email: "joe@example.com" }])

        puts "Officer" + " #{@officer_instance.officer_name}".red.bold + " has a average rating of" + " #{avg_rating}".red.bold + "."

        sleep 1
        go_back_or_repeat("View more average ratings?",user_instance) 
    end

    
    def change_rating(user_instance)
        prompt = new_prompt

        user_reviews = Review.find_by(user_id: user_instance)
    
        if user_reviews
            reviews = Review.all.select {|review| review.user_id == user_instance.id}
            officer_names = reviews.map {|review| review.officer.officer_name}

            officer_selection =  prompt.select("Please select your review to update:".blue.bold, officer_names, cycle: true , echo: false, filter: true)
            
            officer_review = reviews.select {|review| review.officer.officer_name == officer_selection}
            officer_x = Officer.find_by(officer_name: officer_selection)
            puts "\n"
            
            puts "Please update your rating for:".blue.bold + " #{officer_selection}".red.bold
            puts "\n"
            rating = prompt.slider("Rating", max: 10, step: 0.5, default: 0, format: "|:slider| %.1f")
            sleep 1
            puts "\n"
            
            puts "Please include a description of your interaction with:".blue.bold + " #{officer_x.rank} #{officer_x.officer_name}".red.bold
            review_desc = gets.chomp
            puts "\n"
        
            review_id = officer_review.map {|review| review.id}

            puts "Are you sure you want to submit this updated review?".blue.bold
            are_you_sure(user_instance)
            puts "\n"
            
            Review.update(review_id[0], rating: rating, review_desc: review_desc)
            
            puts "You have updated your review of:".blue.bold + " #{officer_selection}".red.bold + " to".blue.bold + " #{rating}".red.bold
        else
            puts "It looks like you have not made any reviews yet. Lets take you back to the main menu."
        end
        sleep 1
        go_back_or_repeat("Do you want to update another review?", user_instance)
    end
    

    def delete_review(user_instance)
        prompt = new_prompt

        user_reviews = Review.find_by(user_id: user_instance)
        if user_reviews
            reviews = Review.all.select {|review| review.user_id == user_instance.id} #selecting all reviews of officers that match reviews by user
            officer_names = reviews.map {|review| review.officer.officer_name} #return names as array of strings
            officer =  prompt.select("Please select a review to delete:".blue.bold, officer_names, cycle: true , echo: false, filter: true)#tty menu
            puts "\n"
            
            officer_review = reviews.select {|review| review.officer.officer_name == officer} #returns review instance associated with the name entered above
            officer_x = Officer.find_by(officer_name: officer) #matching officer instance
            review_id = officer_review.map {|review| review.id} #finds id for review instance
            puts "\n"
        
            puts "Are you sure you want to delete this review?".blue.bold
            are_you_sure(user_instance)
            puts "\n"
            
            Review.destroy(review_id[0]) #deletes review.    
            puts "You have deleted your rating of:".bold + " #{officer}".red.bold
        else
            puts "You do not have any reviews to delete. Lets take you back to the main menu."
        end
        sleep 1

        go_back_or_repeat("Do you want to delete another review?", user_instance)  
    end

end #END OF CLASS




