defmodule VotrWeb.RoomView do
  use VotrWeb, :view

  alias Votr.Voting.User

  @doc """
  Assigns for the form used by the new template.
  """
  def new_form_assigns(socket, assigns) do
    Map.merge(assigns, %{
      action: Routes.live_path(socket, VotrWeb.RoomLive.New),
      submit_text: "Create Room",
      submitting_text: "Creating..."
    })
  end

  # @doc """
  # Assigns for the form used by the edit template.
  # """
  # def edit_form_assigns(conn, assigns) do
  #   Map.merge(assigns, %{
  #     action: Routes.room_path(conn, :update, assigns.room),
  #     submit_text: "Update Room",
  #     submitting_text: "Updating..."
  #   })
  # end

  #  @doc """
  # Assigns for the form used by the edit template.
  # """
  # def new_user_form_assigns(conn, assigns) do
  #   IO.inspect assigns, label: "new_user_form_assigns"
  #   Map.merge(assigns, %{
  #     action: Routes.room_path(conn, :create_user, assigns.room_id),
  #     submit_text: "Join Room",
  #     submitting_text: "Joining..."
  #   })
  # end
end
