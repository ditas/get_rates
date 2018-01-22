defmodule Crypto2Currency do
  use Ecto.Schema

  schema "crypto2currency" do
#    belongs_to :fk_crypto, Crypto
#    belongs_to :fk_currency, Currency
    field :fk_crypto, :integer
    field :fk_currency, :integer
    field :value, :float
  end
end
