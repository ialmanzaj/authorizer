defmodule Authorizer.MixProject do
  use Mix.Project

  def project do
    [
      app: :authorizer,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      mod: {Authorizer, []},
      escript: [
        main_module: Authorizer.CLI
      ],
      # add releases configuration
      releases: [
        # we can name releases anything, this will be prod's config
        prod: [
          # we'll be deploying to Linux only
          include_executables_for: [:unix],
          # have Mix automatically create a tarball after assembly
          steps: [:assemble, :tar]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
