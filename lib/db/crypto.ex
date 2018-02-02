defmodule Crypto do
  use Ecto.Schema

  schema "cryptos" do
    field :name, :string
  end

#  def changeset(crypto, params) do
#    crypto
#    |> Ecto.Changeset.cast(params, [:name])
#    |> Ecto.Changeset.validate_required([:name])
#  end

  def get_id(name) do
    case Db.Repo.get_by(Crypto, name: name) do
      nil -> :undefined
      c -> Map.get(c, :id)
    end
  end

  def get_all() do
    Crypto |> Db.Repo.all() |> List.foldl([], fn(c, acc)->
      [{Map.get(c, :id), Map.get(c, :name)}|acc]
    end)
  end
end
