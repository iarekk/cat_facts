defmodule CatFacts.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CatFacts.DiscordSupervisor
      # Starts a worker by calling: CatFacts.Worker.start_link(arg)
      # {CatFacts.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CatFacts.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
