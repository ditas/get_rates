defmodule HttpHandler do
  import Plug.Conn
  @default_currency "USD"

  def init(opts) do
    Map.put(opts, :my_option, "Hello")
  end

#  def call(%Plug.Conn{request_path: "/" <> name, } = conn, opts) do
#    send_resp(conn, 200, "#{opts[:my_option]}, #{name}")
#  end

  def call(conn, opts) do
    conn1 = fetch_query_params(conn, [])

    IO.inspect(conn1.params)

    case get_cost(conn1.params) do
      {:ok, value} -> send_resp(conn, 200, "Here is your sum: #{value}")
      {:error, reason} -> send_resp(conn, 404, "Something went wrong: #{reason}")
    end
  end

  def get_cost(%{"sum" => sum, "crypto" => crypto, "timestamp" => timestamp}) do
    GetRates.Data.DataController.get_rates(sum, crypto, @default_currency, timestamp)
  end
  def get_cost(%{"sum" => sum, "crypto" => crypto}) do
    GetRates.Data.DataController.get_rates(sum, crypto, @default_currency, :undefined)
  end
  def get_cost(_) do
    {:error, :wrong_request}
  end
end

