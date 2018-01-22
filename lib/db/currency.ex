defmodule Currency do
  use Ecto.Schema

  schema "currencies" do
    field :name, :string
  end

  def get_id(name) do
    Currency |> Db.Repo.get_by(name: name) |> Map.get(:id)
  end
end
