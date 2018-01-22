defmodule Db.Repo.Migrations.AddCurrenciesTable do
  use Ecto.Migration

  def change do
    create table(:currencies) do
#      add :id, :integer, primary_key: true
      add :name, :string
    end
  end
end
