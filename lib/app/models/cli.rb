class CLI
    def welcome
        puts "Welcome to (APP NAME)"
        # binding.pry
        login_menu
    end

    def login_menu
        puts "To get started, please enter a username:"
        username = gets.chomp.downcase.titleize
        puts "Please enter a location"
        location = gets.chomp.downcase.titleize #how do you make the second word capitolized?
        user_instance = User.find_by(username: username, location: location)
        if user_instance
            puts "Welcome back  looks like you already have an acount with us, lets take you to the main menu"
        else
            gender = gender_menu
            race = demographic_menu
            user_instance = User.create(username: username, location: location, race: race, gender: gender)
            puts "thanks for setting up a account!"
        end
        main_menu(user_instance)
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
    

    def main_menu(user_instance)
        prompt = TTY::Prompt.new
        menu_choice = prompt.select("Please select from the folowing options #{user_instance.username}", cycle: true, echo: false) do |menu| sleep 1
            menu.choice 'Rate an officer'
            menu.choice 'View officer average rating'
            menu.choice 'Change a previous review'
            menu.choice 'Delete previous review'
            # menu.choice 'Delete last rating'
            menu.choice 'Exit'
        end

        if menu_choice == 'Rate an officer'
            rate_officer(user_instance)
        elsif menu_choice == 'View officer average rating'
            get_average_rating(user_instance)
        elsif menu_choice == 'Change a previous review'
            change_rating(user_instance)
        elsif menu_choice == 'Delete previous review'
            delete_review(user_instance)
        #   elsif welcome == 'Delete last rating'
            # delete_rating

        else 
            puts "Thanks for stopping by!"
        end
    end


    #     brewery_name = prompt.select("Choose a brewery to rate:", choices, cycle: true, echo: false, filter: true)
    # @brewery = Brewery.find_by(name: brewery_name)

    # provide number rating and provide menu of text options
    # table: officers  
    # :officer_name, :badge_number,  :preicient, :unit, :rank 
    # able to review only officiers alreayd in the DB as the DB hosts all officiers in the DB


    def rate_officer(user_instance)  # (create an officer)
    
        prompt = TTY::Prompt.new

        officer_choices = Officer.all.collect{|officer| officer.officer_name } #-->make a helper mthod
        
        officer = prompt.select("Choose an officer to rate:", officer_choices, cycle: true , echo: false, filter: true)

        @officer_instance = Officer.find_by(officer_name: officer)
        
        puts "You chose #{@officer_instance.officer_name}. Please rate your interaction with the Officer."
        
        rating = prompt.slider("Rating", max: 10, step: 0.5, default: 0, format: "|:slider| %.1f")
    
        puts "Please include a descrition of your interaction with #{@officer_instance.officer_name}."
        review_desc = gets.chomp # need to write out method for review desc
        
        @review_instance = Review.create(user: user_instance, officer: @officer_instance, rating: rating, review_desc: review_desc)
        
        puts "Thank you #{user_instance.username} for your review of Officer #{@officer_instance.officer_name}"
        puts "You have given them a review of #{rating}/10"
        main_menu(user_instance)
    end

    def get_average_rating(user_instance)

        prompt = TTY::Prompt.new

        officer_choices = Officer.all.collect{|officer| officer.officer_name }
        
        officer = prompt.select("Choose officer to veiw their average rating:", officer_choices, cycle: true , echo: false, filter: true)
        
        @officer_instance = Officer.find_by(officer_name: officer)
       
        officer_review_selection = Review.all.select {|review| review.officer_id == @officer_instance.id}

        total_reviews = officer_review_selection.map {|review| review.rating}
        avg_rating = total_reviews.sum / total_reviews.length
        
        puts "Officer #{@officer_instance.officer_name} has a average rating of #{avg_rating}."
        
        main_menu(user_instance)
    end


    def change_rating(user_instance)
        # binding.pry
        
        prompt = TTY::Prompt.new
      

        user_reviews = Review.find_by(user_id: user_instance)
        if user_reviews
            reviews = Review.all.select {|review| review.user_id == user_instance.id}
        
        # take update_review officer_id and match to id in Officer table, return officer name
        officer_names = reviews.map {|review| review.officer.officer_name}
       
        officer_selection =  prompt.select("Please select your review to update:", officer_names, cycle: true , echo: false, filter: true)

        officer_review = reviews.select {|review| review.officer.officer_name == officer_selection}

        officer_x = Officer.find_by(officer_name: officer_selection)

        puts "Please update your rating for #{officer_selection}"
        rating = prompt.slider("Rating", max: 10, step: 0.5, default: 0, format: "|:slider| %.1f")

        puts "Please include a descrition of your interaction with #{@officer_instance.officer_name}."
        review_desc = gets.chomp 
     
        review_id = officer_review.map {|review| review.id}

        Review.update(review_id[0], rating: rating, review_desc: review_desc)    

        puts "You have updated your rating of #{officer_selection} to #{rating}"


        else
            puts "It looks like you have not made any reviews yet. Let's take you back to the main menu"
        end
        main_menu(user_instance)
    end

    def delete_review(user_instance)
        prompt = TTY::Prompt.new
        
        user_reviews = Review.find_by(user_id: user_instance)
        if user_reviews 

            #review.all.select {|review| review.user_id == user_instance.id
            #select officer (tty prompt)
            reviews = Review.all.select {|review| review.user_id == user_instance.id}
            #selecting all reviews of officers that match reviews by user
            officer_names = reviews.map {|review| review.officer.officer_name}
            #return names as array of strings
            officer =  prompt.select("Please select a review to delete:", officer_names, cycle: true , echo: false, filter: true)
            #tty menu
            officer_review = reviews.select {|review| review.officer.officer_name == officer}
            #returns review instance associated with the name entered above
            officer_x = Officer.find_by(officer_name: officer)
            #matching officer instance
        

            review_id = officer_review.map {|review| review.id}
            #finds id for review instance
            Review.destroy(review_id[0]) #rating: rating, review_desc: review_desc)    
            #deletes review.
            puts "you have deleted your rating of #{officer}"
           
        else 
            puts "It looks like you do not have any reviews to delete. Lets take you back to the main menu"
    end
    main_menu(user_instance)
    end

end




