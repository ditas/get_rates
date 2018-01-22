defmodule Plugstarter do

  def start_link() do
    {:ok, _} = Plug.Adapters.Cowboy.http(HttpHandler, %{})
  end
end
