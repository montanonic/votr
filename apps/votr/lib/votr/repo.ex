defmodule Votr.Repo do
  use Ecto.Repo,
    otp_app: :votr,
    adapter: Ecto.Adapters.Postgres
end
