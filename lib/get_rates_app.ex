defmodule GetRatesApp do
  use Application

  def start(_type, _args) do

    # Cowboy
    dispatch_config = :cowboy_router.compile([
      { :_,
        [
          {"/", TestHandler, []},
          {"/static/[...]", :cowboy_static, {:priv_dir,  :get_rates, "static"}},
          {"/rates", GetHandler, []},
          {"/websocket", WebsocketHandler, []},
        ]
      }
    ])

    {:ok, _} = :cowboy.start_clear(
      :http,
      [{:port, 8080}],
      %{:env => %{:dispatch => dispatch_config}}
    )

    GetRates.GetRatesSup.start_link()
  end
end
