defmodule GetRates.Data.DataController do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

#  Callbacks
  def init(_opts) do
    :inets.start()
    :ssl.start()
    {:ok, data} = req()

    :timer.send_interval(15000, :get_rates_data)

    {:ok, Map.put(%{}, :data, data)}
  end

  def handle_call(:get_rates_data, _from, state) do
    {:reply, Map.get(state, :data), state}
  end
  def handle_call({:get_rates, {sum, crypto, currency, timestamp}}, _from, state) do
    reply = handle_request(sum, crypto, currency, timestamp)
    {:reply, reply, state}
  end
  def handle_call({:get_all, timestamp}, _from, state) do
    reply = handle_request(timestamp)
    {:reply, reply, state}
  end
  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def handle_info(:get_rates_data, state) do
    IO.puts("data updated")
    {:ok, data} = req()
    {:noreply, Map.put(state, :data, data)}
  end
  def handle_info(_msg, state) do
    {:noreply, state}
  end

#  External functions
  def test do
    GenServer.call(__MODULE__, :get_rates_data)
  end

  def get_rates(sum, crypto, currency, timestamp) do
    GenServer.call(__MODULE__, {:get_rates, {sum, crypto, currency, timestamp}})
  end

  def get_all(timestamp) do
    GenServer.call(__MODULE__, {:get_all, timestamp})
  end

#  Internal functions

  # %{"BCH" => %{"USD" => 1754.41}, "BTC" => %{"USD" => 11380.26}, "ETH" => %{"USD" => 1031.33}}
  def req() do
    case :httpc.request('https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH,BCH&tsyms=USD') do
      {:ok, {{_, 200, _}, _headers, data}} ->
        data_map = Poison.decode!(data)
        res = handle_data(data_map)
        {res, data_map}
      resp -> {:error, :wrong_response, resp}
    end
  end

  def store_crypto(name) do
    crypto = %Crypto{name: name}
#    changeset = Crypto.changeset(crypto, %{})
    {:ok, _} = Db.Repo.insert(crypto)
  end

  def store_currency(name) do
    currency = %Currency{name: name}
    {:ok, _} = Db.Repo.insert(currency)
  end

  def store_crypto2currency(crypto_id, currency_id, value) do
    case Crypto2Currency.set_row(crypto_id, currency_id, value) do
      {:ok, _} -> :ok
      _ -> :error
    end
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

  def handle_request(sum, crypto, currency, timestamp) do
    crypto_id = Crypto.get_id(crypto)
    currency_id = Currency.get_id(currency)
    case Crypto2Currency.get_value(crypto_id, currency_id, timestamp) do
      {:error, reason} -> {:error, reason}
      {:ok, price} -> {:ok, String.to_integer(sum) * price}
    end
  end
  def handle_request(timestamp) do
    cryptos = Crypto.get_all()
    currencies = Currency.get_all()
    List.foldl(cryptos, [], fn({crypto_id, crypto_name}, acc)->
      crypto_price = List.foldl(currencies, [], fn({currency_id, currrency_name}, _)->
        case Crypto2Currency.get_value(crypto_id, currency_id, timestamp) do
          {:error, reason} -> {:error, reason}
          {:ok, price} -> {crypto_name, currrency_name, price}
        end
      end)
      [crypto_price|acc]
    end)
  end
end