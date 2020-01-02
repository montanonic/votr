defmodule Votr.Store do
  @moduledoc """
  Storage module backed by an ETS table. Used in places where more ephemeral
  storage is valid and a database is overkill. This is a good fit for real-time
  voting features in this project.
  """

  use GenServer

  #
  # API
  #

  @doc """
  Put any map containing an `id` field into storage using its `id` as its key. This
  is a natural fit for `Ecto`-driven data.
  """
  def put(%{id: id} = value) do
    true = :ets.insert(__MODULE__, {id, value})
    :ok
  end

  @doc """
  Put a `value` into the table at the `key`.
  """
  def put(key, value) do
    true = :ets.insert(__MODULE__, {key, value})
    :ok
  end

  def fetch(key) do
    {:ok, :ets.lookup_element(__MODULE__, key, 2)}
  rescue
    ArgumentError -> :error
  end

  # def update(key, func) do
  #   :ets.update_element(__MODULE__, key, arg3)
  # end

  #
  # Implementation
  #

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(_opts) do
    {:ok, new_table()}
  end

  defp new_table do
    :ets.new(__MODULE__, [
      :set,
      :named_table,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])
  end
end
