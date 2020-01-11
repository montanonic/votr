defmodule VotrWeb.UserChannel do
  use VotrWeb, :channel

  @impl true
  def join("user", _params, socket) do
    {:ok, "hello you joined", socket}
  end
end
