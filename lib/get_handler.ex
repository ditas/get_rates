defmodule GetHandler do
  @default_currency "USD"

  def init(req, state) do
    handle(req, state)
  end

  def handle(request, state) do
    request_data = :cowboy_req.parse_qs(request)

    IO.inspect(request_data)

    reply = build_response(request_data, request)
    {:ok, reply, state}
  end

  def terminate(_reason, _request, _state) do
    :ok
  end

  # Internal functions
  def build_response(request_data, request) do
    case get_cost(request_data) do
      {:ok, value} -> :cowboy_req.reply(200, %{<<"content-type">> => <<"text/plain">>}, "Here is your sum: #{value}", request)
      {:error, reason} -> :cowboy_req.reply(404, %{<<"content-type">> => <<"text/plain">>}, "Something went wrong: #{reason}", request)
    end
  end

  def get_cost([{"sum", sum_str}, {"crypto", crypto_str}, {"timestamp", timestamp_str}]) do
    GetRates.Data.DataController.get_rates(sum_str, crypto_str, @default_currency, timestamp_str)
  end
  def get_cost([{"sum", sum_str}, {"crypto", crypto_str}]) do
    GetRates.Data.DataController.get_rates(sum_str, crypto_str, @default_currency, :undefined)
  end
  def get_cost(_) do
    {:error, :wrong_request}
  end

  def get_all(timestamp) do
    GetRates.Data.DataController.get_all(timestamp)
  end

end
