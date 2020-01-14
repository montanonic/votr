defmodule VotrWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use VotrWeb, :controller
      use VotrWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: VotrWeb
      import Plug.Conn
      import Phoenix.LiveView.Controller
      import VotrWeb.Gettext
      alias VotrWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/votr_web/templates",
        namespace: VotrWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Phoenix.LiveView,
        only: [
          live_render: 2,
          live_render: 3,
          live_link: 1,
          live_link: 2,
          live_component: 2,
          live_component: 3,
          live_component: 4
        ]

      import VotrWeb.ErrorHelpers
      import VotrWeb.Gettext
      alias VotrWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import VotrWeb.Gettext
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView
      unquote(live())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent
      unquote(live())
    end
  end

  # Common imports for both live_view and live_component.
  defp live do
    quote do
      alias VotrWeb.Router.Helpers, as: Routes
      alias Phoenix.PubSub
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
