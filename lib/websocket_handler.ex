defmodule WebsocketHandler do

   def init(req, opts) do
     {:cowboy_websocket, req, opts}
   end

   def websocket_init(state) do
    :erlang.start_timer(1000, self(), [])
    {:ok, state}
   end

   def websocket_handle({:text, msg}, state) do
     {:reply, {:text, "Test #{msg}"}, state}
   end
   def websocket_handle(_, state) do
     {:ok, state}
   end

   def websocket_info({:timeout, _ref, _msg}, state) do
     :erlang.start_timer(1000, self(), [])

     {:ok, message} = JSEX.encode(%{time: "ХУЙ"})

     {:reply, {:text, message}, state}
   end
   def websocket_info(_, state) do
     {:ok, state}
   end

end

