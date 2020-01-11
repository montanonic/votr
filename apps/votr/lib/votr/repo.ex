defmodule Votr.Repo do
  use Ecto.Repo,
    otp_app: :votr,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Counts the number of records in a given table or query.

  Relies upon the presence of an `id` field in those record to work, but, we can
  expect basically every record to have an `id` field.
  """
  def count(table_or_query) do
    aggregate(table_or_query, :count, :id)
  end
end
