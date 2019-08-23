defmodule StreamLiveBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :stream_live_bot,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {StreamLiveBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 4.0.1"},
      {:httpoison, "~> 1.5"},
      {:tg_bot, "~> 0.1.2"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, "~> 0.15"},
      {:sched_ex, "~> 1.0"},
    ]
  end

  defp aliases do
    [
      server: ["run --no-halt"]
    ]
  end
end
