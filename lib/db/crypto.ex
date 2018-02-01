defmodule Crypto do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "cryptos" do
    field :name, :string
  end

#  def changeset(crypto, params) do
#    crypto
#    |> Ecto.Changeset.cast(params, [:name])
#    |> Ecto.Changeset.validate_required([:name])
#  end

  def get_id(name) do
    Crypto |> Db.Repo.get_by(name: name) |> Map.get(:id)
  end

  def get_all() do
    Crypto |> Db.Repo.all() |> Map.get(:id)
  end
end
