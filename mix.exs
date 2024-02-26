defmodule KinoLivereload.MixProject do
  use Mix.Project

  def project do
    [
      app: :kino_livereload,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "Live Reload for Livebook cells"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def package do
    [
      maintainers: ["Thomas Millar"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/thmsmlr/kino_livereload"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:file_system, "~> 1.0"},
      {:kino, "~> 0.12.2"}
    ]
  end
end
