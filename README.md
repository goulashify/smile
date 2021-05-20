# Emote

Small lib for converting emoticons and emoji names to emoji characters:

```elixir 
Emote.convert_text("my emoji game is :fire: ;-)")
# > "my emoji game is 🔥 😉"
```

There's known limitations:
    
1. Emojis combined together don't work, ex.: ":woo:pile_of_poo:hoo:" would not convert.


## License

WTFPL, as originally forked from https://github.com/danigulyas/smile