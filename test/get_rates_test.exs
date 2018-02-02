defmodule GetRatesTest do
  use ExUnit.Case
  doctest GetRatesApp

  @default_currency "USD"

  test "basic test" do
    assert %{"BCH" => %{"USD" => _bch_price}, "BTC" => %{"USD" => _btc_price},
             "ETH" => %{"USD" => _eth_price}} = GetRates.Data.DataController.test()
  end

  test "receiving by timer test" do
    assert {:ok, _map} = GetRates.Data.DataController.req()
  end

  test "getting cost without timestamp test" do
    assert {:ok, value} = GetRates.Data.DataController.get_rates("1", "BTC", "USD", :undefined)
    assert is_float(value) == true

    assert %{"BCH" => %{"USD" => _bch_price}, "BTC" => %{"USD" => btc_price},
             "ETH" => %{"USD" => _eth_price}} = GetRates.Data.DataController.test()

    assert btc_price == value
  end

#  test "getting cost with has_data_timestamp test" do
#    assert {:ok, value} = GetRates.Data.DataController.get_rates("1", "BTC", "USD", "2018-01-22 14:15:31")
#    assert is_float(value) == true
#  end

  test "getting cost with no_data_timestamp test" do
    assert {:error, "No data found for 1 & 1 & 2018-01-01 14:15:31"} = GetRates.Data.DataController.get_rates("1", "BTC", "USD", "2018-01-01 14:15:31")
  end
end
