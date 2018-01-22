# GetRates

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `get_rates` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:get_rates, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/get_rates](https://hexdocs.pm/get_rates).

# Как пользоваться

##### Данные // Нужно синхронизировать в базу рейты криптовалют BTC/ETH/BCH. В качестве источника данных можно использовать https://www.cryptocompare.com/api/ (не используя сторонние либы для реализации работы по расписанию)

Для корректной работы необходимо залить данные по видам крипты и валюты для конвертации.
Делаем так:

```elixir
iex -S mix

GetRates.Data.DataController.store_crypto("BTC")
...
GetRates.Data.DataController.store_crypto("BCH")
...
GetRates.Data.DataController.store_crypto("ETH")
...
GetRates.Data.DataController.store_currency("USD")
...
```
Данные обновляются каждые 15 секунд. Значение захардкожено в DataController.init().

##### Калькулятор(REST API) // Клиент может может отправить сумму в криптовалюте ее символ и время расчета, мы должны вернуть ему сумму в USD по ближайшему рейту на это время. Если время не передал то отдаем по последнему. 

Заходим на [http://localhost:4000?sum=сумма_крипты&crypto=имя_крипты&timestamp=YYYY-MM-DD HH24:MI:SS](http://localhost:4000/?sum=1000&crypto=BTC&timestamp=2018-01-22%2014:15:31)

Соответственно, поле timestamp можно проигнорировать, тогда будет возвращено ближайшее к текущему моменту значение стоимости крипты



