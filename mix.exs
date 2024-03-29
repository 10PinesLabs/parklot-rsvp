defmodule ParklotRsvp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :parklot_rsvp,
      version: "0.0.1",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ParklotRsvp.Application, [:bamboo]},
      extra_applications: [:logger, :runtime_tools, :timex, :timex_ecto, :httpoison]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.3"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:timex, "~> 3.0"},
      {:timex_ecto, "~> 3.0"},
      {:bamboo, "~> 1.0"},
      {:bamboo_smtp, "~> 1.5.0"},
      {:httpoison, "~> 1.2"},
      {:ex_matchers, "~> 0.1.2", only: :test},
      {:mox, "~> 0.4", only: :test},
      {:google_api_calendar, "~> 0.21"},
      {:goth, "~> 1.2.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
