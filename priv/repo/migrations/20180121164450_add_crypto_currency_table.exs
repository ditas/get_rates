defmodule Db.Repo.Migrations.AddCryptoCurrencyTable do
  use Ecto.Migration

  def change do
    create table(:crypto2currency, primary_key: false) do
      add :timestamp, :naive_datetime, default: fragment("now()"), primary_key: true
      add :fk_crypto, references("cryptos")
      add :fk_currency, references("currencies")
      add :value, :float
    end
  end
end
