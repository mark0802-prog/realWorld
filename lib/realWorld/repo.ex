defmodule RealWorld.Repo do
  use Ecto.Repo,
    otp_app: :realWorld,
    adapter: Ecto.Adapters.Postgres
end
