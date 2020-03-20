defmodule PlayerBio.Application do
  @moduledoc """
  OTP Application spec for PlayerBio
  """

  use Application

  def start(_type, _args) do
    port = Application.get_env(:player_bio, :port, 8080)

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: PlayerBio.Endpoint,
        options: [port: port]
      )
    ]

    opts = [strategy: :one_for_one, name: PlayerBio.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
