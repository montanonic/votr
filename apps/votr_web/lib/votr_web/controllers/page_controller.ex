defmodule VotrWeb.PageController do
  use VotrWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
