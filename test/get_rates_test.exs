defmodule GetRatesTest do
  use ExUnit.Case
  doctest GetRatesApp

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
  end

end
