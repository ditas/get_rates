defmodule Db.Repo.Migrations.AddCryptosTable do
  use Ecto.Migration

  def change do
    create table(:cryptos) do
#      add :id, :integer, primary_key: true
      add :name, :string
    end
  end
end
