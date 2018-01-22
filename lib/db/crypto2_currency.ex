defmodule Crypto2Currency do
  use Ecto.Schema

  schema "crypto2currency" do
#    belongs_to :fk_crypto, Crypto
#    belongs_to :fk_currency, Currency
    field :fk_crypto, :integer
    field :fk_currency, :integer
    field :value, :float
  end

  def set_row(crypto_id, currency_id, value) do
    Ecto.Adapters.SQL.query(Db.Repo, "INSERT INTO crypto2currency (fk_crypto, fk_currency, value) VALUES ($1, $2, $3)", [crypto_id, currency_id, value])
  end

  def get_value(crypto_id, currency_id, :undefined) do
    {:ok, %{rows: [[row]]}} = Ecto.Adapters.SQL.query(Db.Repo, "SELECT value FROM crypto2currency WHERE fk_crypto = $1 AND fk_currency = $2 AND timestamp::time >= now()::time - interval '15 second' order by timestamp desc limit 1", [crypto_id, currency_id])

    IO.inspect(row)

    row
  end
  def get_value(crypto_id, currency_id, timestamp) do
    {:ok, %{rows: [[row]]}} = Ecto.Adapters.SQL.query(Db.Repo, "SELECT value FROM crypto2currency WHERE fk_crypto = $1 AND fk_currency = $2 AND timestamp::time >= to_timestamp($3, 'YYYY-MM-DD HH24:MI:SS')::time - interval '15 second' order by timestamp desc limit 1", [crypto_id, currency_id, timestamp])
    row
  end
end