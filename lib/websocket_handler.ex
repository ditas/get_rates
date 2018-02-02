defmodule WebsocketHandler do

   def init(req, opts) do
     {:cowboy_websocket, req, opts}
   end

   def websocket_init(state) do
    :erlang.start_timer(1000, self(), [])
    {:ok, state}
   end

   def websocket_handle({:text, content}, state) do

#     IO.inspect(content)

     {:ok, %{"message" => timestamp}} = Poison.decode(content)

     IO.inspect(timestamp)

     rates = GetHandler.get_all(timestamp)
     rates_all = List.foldl(rates, [], fn(r, acc)->
       res = Tuple.to_list(r) |> Enum.join(", ")
       [res|acc]
     end)

#     IO.inspect(rates_all)

     {:ok, message} = Poison.encode(%{reply: Enum.join(rates_all, "; ")})
     {:reply, {:text, message}, state}
   end
   def websocket_handle(_msg, state) do
     {:ok, state}
   end

   def websocket_info({:timeout, _ref, _msg}, state) do
     :erlang.start_timer(15000, self(), [])

     rates = GetHandler.get_all(:undefined)

#     IO.inspect(rates)

     rates_all = List.foldl(rates, [], fn(r, acc)->
        res = Tuple.to_list(r) |> Enum.join(", ")
        [res|acc]
     end)

#     IO.inspect(rates_all)

     {:ok, message} = Poison.encode(%{rates: Enum.join(rates_all, "; ")})

#     IO.inspect(message)

     {:reply, {:text, message}, state}
   end
   def websocket_info(_msg, state) do
     {:ok, state}
   end

end

