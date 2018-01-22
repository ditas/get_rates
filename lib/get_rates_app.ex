defmodule GetRatesApp do
  use Application

  def start(_type, _args) do
    GetRates.GetRatesSup.start_link()
  end
end
