defmodule Emote.Mixfile do
  use Mix.Project

  def project do
    [app: :emote,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: dependencies(),
     description: description(),
     package: package()]
  end

  defp dependencies do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp description do
    """
      Small lib for converting emoticons and emoji mappers to emoji characters
    """
  end

  defp package do
    [
      name: :smile,
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Bonfire"],
      licenses: ["WTFPL"],
      links: %{"GitHub" => "https://github.com/bonfire-networks/emote"}
    ]
  end
end
