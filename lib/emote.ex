defmodule Emote do
  @moduledoc "Module for converting emoticons and emoji names to real emojis"
  require Logger

  @external_resource emojis = Path.join([__DIR__, "emojis.txt"])
  @external_resource emoticons = Path.join([__DIR__, "emoticons.txt"])

  include = [
    emojis,
    emoticons
  ]

  # load all
  all =
    for file_path <- include do
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

  # load the list of possible strings we can lookup
  # names_list = for {name, emoji} <- all do
  #   name
  # end

  # define substitution functions for each
  for {name, emoji} <- all do
    def lookup(unquote(name)), do: unquote(emoji)
  end

  @doc "Converts emoticon or name to emoji, eg \":face_with_ok_gesture:\" to 🙆, with fallback returning nil if emoji not found."
  def lookup(_), do: nil

  @doc "Converts mapping to emoji, eg \":face_with_ok_gesture:\" to 🙆, returns original text when emoji not found, helper function for convert_text."
  # adjust this based on shortest/longest emoticons / emoji names
  def convert_word(word)
      when is_binary(word) and byte_size(word) > 1 and byte_size(word) < 85 do
    case lookup(word) do
      nil -> word
      emoji -> emoji
    end
  end

  def convert_word(word), do: word

  @doc "Converts text in a way that it replaces mapped emojis to real emojis."
  def convert_text(text) when is_binary(text) do
    text
    # |> String.split(~r{<|>}, include_captures: true)
    # |> Enum.flat_map(&String.split/1)
    |> String.split()
    |> Enum.map(&convert_word/1)
    |> Enum.join(" ")
  end

  # @doc "Converts text in a way that it replaces mapped emojis to real emojis."
  # def convert_text(text) when is_binary(text) do
  #   text
  #   |> String.replace(unquote(names_list), &lookup/1)
  # end

  def convert_text(text) do
    Logger.error("Emote: expected binary, got: #{inspect(text)}")
    text
  end
end