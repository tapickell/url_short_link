defmodule UrlShortenerWeb.GeneratorLive.Index do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.UrlLinks

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket = assign(socket, :url_link, UrlLinks.empty_url_link())
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket = apply_action(socket, socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Generate Short Url")
  end

  @impl Phoenix.LiveView
  def handle_event("generate_short_url", %{"long_url" => long_url}, socket) do
    with {:ok, %{short_url_id: short_url_id}} = UrlLinks.new_url_link(long_url)
    base = UrlShortenerWeb.Endpoint.url()
    short_url = base <> "/" <> short_url_id
    socket = socket |> assign(short_url: short_url)

    {:noreply, socket}
  end

  def generator_form(%{url_link: changeset} = assigns) do
    assigns = assign(assigns, changeset: changeset, url_link: nil)

    ~H"""
    <.form for={@changeset} class={@class} id={@id} phx-submit="generate_short_url">
      <.input field={@changeset[:long_url]} />
      <input type="submit" value="Generate Short Url" />
    </.form>
    """
  end
end
