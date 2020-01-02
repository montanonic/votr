defmodule VotrWeb.MainLive do
  use VotrWeb, :live_view

  @impl true
  def render(assigns) do
    VotrWeb.PageView.render("main.html", assigns)
  end

  @impl true
  def mount(_session, socket) do
    {:ok, socket}
  end
end
