defmodule Emote do
  @moduledoc "Module for converting emoticons and emoji names to real emojis"
  require Logger
  
  emojis = Path.join([__DIR__, "emojis.txt"])
  emoticons = Path.join([__DIR__, "emoticons.txt"])
  # TODO: use @external_resource ? (removed because it was causing constant recompilation)

  # load all
  # all =
    for file_path <- [
    emojis,
    emoticons
  ] do
      for line <- File.stream!(file_path, [], :line) do
        [emoji, name] =
          line
          |> String.split(" ", parts: 2)
          |> Enum.map(&String.trim/1)

        {name, emoji}
      end
    end
    |> List.flatten()
  # |> IO.inspect()
  # define substitution functions for each
  # for {name, emoji} <- all do
    |> Enum.map(fn {name, emoji} ->
    defp emoji(unquote(name)), do: unquote(emoji)
  end)

  # load the list of possible strings we can lookup
  # names_list = for {name, emoji} <- all do
  #   name
  # end

  #doc "Converts emoticon or name to emoji, eg \":face_with_ok_gesture:\" to 🙆, with fallback returning nil if emoji not found."
  defp emoji(_), do: nil

  @doc "Converts mapping to emoji, eg \":face_with_ok_gesture:\" to 🙆, returns original text when emoji not found, helper function for convert_text."
  # adjust this based on shortest/longest emoticons / emoji names
  def convert_word(word)
      when is_binary(word) and byte_size(word) > 1 and byte_size(word) < 85 do
    # TODO? only lookup if starts/ends with ":" (but wouldn't work for emoticons)
    case emoji(word) do
      nil -> word
      emoji -> emoji
    end
  end
  def convert_word(word), do: word 

  @doc "Converts text in a way that it replaces mapped emojis to real emojis."
  def convert_text(text, custom_emoji \\ []) 

  def convert_text(text, custom_emoji) when is_binary(text) do
    text
    # |> String.split(~r{<|>}, include_captures: true)
    # |> Enum.flat_map(&String.split/1)
    |> String.split("\n")
    |> Enum.map(& convert_line(&1))
    |> Enum.join("\n")
    |> maybe_custom(custom_emoji)
  end

  # @doc "Converts text in a way that it replaces mapped emojis to real emojis."
  # def convert_text(text, custom_emoji) when is_binary(text) do
  #   text
  #   |> String.replace(unquote(names_list), &emoji/1)
  # end

  def convert_text(text, _custom_emoji) do
    Logger.error("Emote: expected binary, got: #{inspect(text)}")
    text
  end

  defp convert_line(text) when is_binary(text) do
    text
    # |> String.split(~r{<|>}, include_captures: true)
    # |> Enum.flat_map(&String.split/1)
    |> String.split() # by whitespace
    |> Enum.map(& convert_word(&1))
    |> Enum.join(" ")
  end
  
  def maybe_custom(text, custom_emoji) when is_list(custom_emoji) or is_map(custom_emoji) do
    Enum.reduce(custom_emoji, text, fn
      {emoji, file}, text ->
        String.replace(text, ":#{emoji}:", prepare_emoji_code(emoji, text_only(file)))
    end)
  end

  defp prepare_emoji_code(emoji, file) do
    # TODO: support SVG ones?
    "<img class='emoji #{emoji}' alt='#{emoji}' title=':#{emoji}:' src='#{(file)}' />"
  end

    defp text_only(content) when is_binary(content) do
    if Code.ensure_loaded?(HtmlSanitizeEx) do
      HtmlSanitizeEx.strip_tags(content)
    else
      # TODO: add as optional dep?
      content
      |> Phoenix.HTML.html_escape()
      |> Phoenix.HTML.safe_to_string()
    end
  end


  def lookup(":"<>_ = emoji), do: emoji(emoji) 
  def lookup(emoji), do: emoji(":#{emoji}:") 

end
