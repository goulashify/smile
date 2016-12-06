defmodule Smile.Mixfile do
  use Mix.Project

  def project do
    [app: :smile,
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
      Small lib for converting emoji mappers to emoji characters, like in Slack messages, see GitHub for desc please.
    """
  end

  defp package do
    [
      name: :smile,
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Daniel Gulyas"],
      licenses: ["WTFPL"],
      links: %{"GitHub" => "https://github.com/danigulyas/smile"}
    ]
  end
end
