
#     def login 
#       prompt = new_prompt
              
#       puts "Please enter your username:".blue.bold
#       username = gets.chomp.downcase.titleize
#       puts "\n"
      
#       password = prompt.mask("Enter your password".blue.bold) 
#       @user_instance = User.find_by(username: username, password: password)
      
#       if @user_instance
#           puts "\n"
#           puts "Welcome back looks like you already have an acount with us, lets take you to the Main Menu"  
#           sleep 3
#           main_menu
#       else
#           puts "\n"
#           puts "Looks like you don't have an account set up with us, let's get you started"
#           sleep 3
#           sign_up
#       end
#   end