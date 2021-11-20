defmodule Emote do
  @moduledoc "Module for converting emoticons and emoji names to real emojis"
  require Logger

  @external_resource emojis = Path.join([__DIR__, "emojis.txt"])
  @external_resource emoticons = Path.join([__DIR__, "emoticons.txt"])

  include = [
    emojis,
    emoticons
  ]

  for file_path <- include do
    for line <- File.stream!(file_path, [], :line) do
      [emoji, name] = line
      |> String.split(" ")
      |> Enum.map(&String.trim/1)

      def lookup(unquote(name)), do: unquote(emoji)
    end
  end

  @doc "Converts emoticon or name to emoji, eg \":face_with_ok_gesture:\" to 🙆, with fallback returning nil if emoji not found."
  def lookup(_), do: nil

  @doc "Converts mapping to emoji, eg \":face_with_ok_gesture:\" to 🙆, returns original text when emoji not found, helper function for convert_text."
  def convert_word(word) do
    case word |> lookup() do
      nil -> word
      emoji -> emoji
    end
  end

  @doc "Converts text in a way that it replaces mapped emojis to real emojis."
  def convert_text(text) when is_binary(text) do
    text
    |> String.split()
    |> Enum.map(&convert_word/1)
    |> Enum.join(" ")
  end

  def convert_text(text) do
    Logger.error("Emote: expected binary, got: #{inspect text}")
    nil
  end

end
