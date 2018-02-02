defmodule Currency do
  use Ecto.Schema

  schema "currencies" do
    field :name, :string
  end

  def get_id(name) do
    Currency |> Db.Repo.get_by(name: name) |> Map.get(:id)
  end

  def get_all() do
    Currency |> Db.Repo.all() |> List.foldl([], fn(c, acc)->
      [{Map.get(c, :id), Map.get(c, :name)}|acc]
    end)
  end
end


#** (BadMapError) expected a map, got: [%Crypto{__meta__: #Ecto.Schema.Metadata<:loaded, "cryptos">, id: 1, name: "BTC"}, %Crypto{__meta__: #Ecto.Schema.Metadata<:loaded, "cryptos">, id: 2, name: "BCH"}, %Crypto{__meta__: #Ecto.Schema.Metadata<:loaded, "cryptos">, id: 3, name: "ETH"}]
