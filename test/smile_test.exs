defmodule EmoteTest do
  use ExUnit.Case
  import Emote
  doctest Emote

  describe "lookup()" do
    test "should convert single emoticons correctly", do: assert lookup(":pile_of_poo:") == "💩"
    test "should return the given text when not found", do: assert lookup(":not_yet_existent_emoji:") == nil
  end

  describe "convert_mapping_to_emoji" do
    test "should return emoji when called correctly", do: assert convert_text(":face_with_ok_gesture:") == "🙆"
    test "should return original text when emoji not found", do: assert convert_text(":not_yet_existent_emoji:") == ":not_yet_existent_emoji:"
  end

  test "converts fine when surrounded by whitespace" do
    assert convert_text("tech debt is :pile_of_poo:") == "tech debt is 💩"
    assert convert_text(":woo:pile_of_poo:hoo: and it's done!") == ":woo:pile_of_poo:hoo: and it's done!"
  end

  test "converts more text fine" do
    assert convert_text("my emoji game is :fire: ;-)") == "my emoji game is 🔥 😉"
  end

  test "converts an emoji within an html tag if there's whitespace" do
    assert convert_text("<p>:)</p>") == "<p>:)</p>"
    assert convert_text("<p> :) </p>") == "<p> 😊 </p>"
  end
end
