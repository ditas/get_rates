defmodule Currency do
  use Ecto.Schema

  schema "currencies" do
    field :name, :string
  end

  def get_id(name) do
    case Db.Repo.get_by(Currency, name: name) do
      nil -> :undefined
      c -> Map.get(c, :id)
    end
  end

  def get_all() do
    Currency |> Db.Repo.all() |> List.foldl([], fn(c, acc)->
      [{Map.get(c, :id), Map.get(c, :name)}|acc]
    end)
  end
end
