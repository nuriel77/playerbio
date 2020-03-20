defmodule PlayerBio.Endpoint do
  use Plug.Router

  # A plug for generating a unique request id for each request
  plug(Plug.RequestId)
  # Using Plug.Logger for logging request information
  plug(Plug.CustomLogger, log: :info)
  # responsible for matching routes
  plug(:match)
  # responsible for dispatching responses
  plug(:dispatch)

  get "/ping" do
    conn
    |> put_resp_content_type("plain/text")
    |> send_resp(200, "pong!")
  end

  get "/player" do
    player = PlayerBio.Generator.new() |> Jason.encode!()

    # Artificial delay between 0 and 2 seconds
    :timer.sleep(Enum.random(0..2000))

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, player)
  end

  get "/metrics" do
    metrics = Prometheus.Format.Text.format(:default)
    send_resp(conn, 200, metrics)
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
