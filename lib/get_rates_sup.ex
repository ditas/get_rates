defmodule GetRates.GetRatesSup do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      supervisor(Db.Repo, [], restart: :permanent),
      worker(GetRates.Data.DataController, [], restart: :permanent),
      worker(Plugstarter, [], restart: :permanent)
    ]

    supervise(children, strategy: :one_for_one)
  end
end