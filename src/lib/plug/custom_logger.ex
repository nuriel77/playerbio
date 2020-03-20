defmodule Plug.CustomLogger do
  @moduledoc """
  A plug for logging basic request information in the format:

      request-id=uq8hs30oafhj5vve8ji5pmp7mtopc08f method=GET path=/index.html
      request-id=uq8hs30oafhj5vve8ji5pmp7mtopc08f method=GET path=/index.html status=200 body="pong!"

  To use it, just plug it into the desired module.

      plug Plug.CustomLogger, log: :debug

  ## Options

    * `:log` - The log level at which this plug should log its request info.
      Default is `:info`.
  """

  require Logger
  alias Plug.Conn
  @behaviour Plug

  def init(opts) do
    Keyword.get(opts, :log, :info)
  end

  def call(conn, level) do
    id = conn.resp_headers |> Map.new() |> Map.get("x-request-id")

    Logger.log(level, "request-id=#{id} method=#{conn.method} path=#{conn.request_path}")

    Conn.register_before_send(conn, fn conn ->
      status = Integer.to_string(conn.status)

      Logger.log(
        level,
        "request-id=#{id} method=#{conn.method} path=#{conn.request_path} status=#{status} body=#{
          inspect(format_body(conn.resp_body))
        }"
      )

      conn
    end)
  end

  defp format_body(body) do
    length = Kernel.min(256, byte_size(body))
    <<resp::binary-size(length), _::binary>> = body
    resp
  end
end
