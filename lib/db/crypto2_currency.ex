defmodule Crypto2Currency do
  use Ecto.Schema

  schema "crypto2currency" do
    belongs_to :fk_crypto, Crypto
    belongs_to :fk_currency, Currency
    field :value, :float
  end
end
