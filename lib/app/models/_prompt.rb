def new_prompt
    system "clear"
        puts render_banner
        prompt = TTY::Prompt.new(active_color: :red)
end