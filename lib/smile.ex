defmodule Smile do
  @moduledoc "Module for converting mapped emojis to real emojis slack-like emoji conversions."
  
  @external_resource file_path = Path.join([__DIR__, "emojis.txt"])

  for line <- File.stream!(file_path, [], :line) do
    [emoji, name] = line |> String.split(" ") |> Enum.map(&String.trim/1)    

    def convert_name_to_emoji(unquote(name)), do: unquote(emoji)
  end

  @doc "Converts name to emoji, eg \"face_with_ok_gesture\" to 🙆, with fallback returning original value if emoji not found."
  def convert_name_to_emoji(text), do: text

  @doc "Converts mapping to emoji, eg \":face_with_ok_gesture:\" to 🙆, returns original text when emoji not found, helper function for convert_text."
  def convert_mapping_to_emoji(mapping) do
    name = mapping |> String.trim |> String.slice(1..-2)
    
    case convert_name_to_emoji(name) do
      ^name -> mapping
      emoji -> emoji
    end
  end

  @doc "Converts text in a way that it replaces mapped emojis to real emojis."
  def convert_text(text) do
    Regex.replace(~r/:[a-z|0-9|_]*:/, text, &convert_mapping_to_emoji/1)
  end
end
