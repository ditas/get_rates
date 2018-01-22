defmodule GetRates.Data.DataController do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

#  Callbacks
  def init(_opts) do
    :inets.start()
    :ssl.start()
    data = req()

    :timer.send_interval(15000, :get_rates_data)

    {:ok, Map.put(%{}, :data, data)}
  end

  def handle_call(:get_rates_data, _from, state) do
    {:reply, Map.get(state, :data), state}
  end
  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def handle_info(:get_rates_data, state) do
    IO.puts("data updated")
    data = req()
    {:noreply, Map.put(state, :data, data)}
  end
  def handle_info(_msg, state) do
    {:noreply, state}
  end

#  External functions
  def test do
    GenServer.call(__MODULE__, :get_rates_data)
  end

#  Internal functions

  # %{"BCH" => %{"USD" => 1754.41}, "BTC" => %{"USD" => 11380.26}, "ETH" => %{"USD" => 1031.33}}
  def req() do
    case :httpc.request('https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH,BCH&tsyms=USD') do
      {:ok, {{_, 200, _}, _headers, data}} ->
        data_map = Poison.decode!(data)
        handle_data(data_map)
        data_map
      resp -> {:error, :wrong_response, resp}
    end
  end

  def store_crypto(name) do
    crypto = %Crypto{name: name}
#    changeset = Crypto.changeset(crypto, %{})
    Db.Repo.insert(crypto)
  end

  def store_currency(name) do
    currency = %Currency{name: name}
    Db.Repo.insert(currency)
  end

  def store_crypto2currency(crypto_id, currency_id, value) do
    crypto2currency = %Crypto2Currency{fk_crypto: crypto_id, fk_currency: currency_id, value: value}
    Db.Repo.insert(crypto2currency)
  end

  def handle_data(map) do
    crypto_keys = Map.keys(map)
    List.foldl(crypto_keys, [], fn(k, _)->
      crypto_id = Crypto.get_id(k)
      currency_map = Map.get(map, k)
      currency_keys = Map.keys(currency_map)
      List.foldl(currency_keys, [], fn(ck, _)->
        currency_id = Currency.get_id(ck)
        store_crypto2currency(crypto_id, currency_id, Map.get(currency_map, ck))
      end)
    end)
  end
end