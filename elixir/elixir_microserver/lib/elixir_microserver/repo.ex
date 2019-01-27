defmodule ElixirMicroserver.Repo do
  use Ecto.Repo,
    otp_app: :elixir_microserver,
    adapter: Ecto.Adapters.Postgres
end
