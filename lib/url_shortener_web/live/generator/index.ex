defmodule UrlShortenerWeb.GeneratorLive.Index do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.UrlLinks

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:url_link, UrlLinks.empty_changeset())
      |> assign(:short_url, nil)

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
  def handle_event("generate_short_url", %{"url_link" => %{"long_url" => long_url}}, socket) do
    with {:ok, %{short_url_id: short_url_id}} = url_link = UrlLinks.new_url_link(long_url) do
      base = UrlShortenerWeb.Endpoint.url()
      short_url = base <> "/" <> short_url_id
      socket = socket |> assign(short_url: short_url)

      {:noreply, socket}
    end
  end

  def generator_form(%{url_link: changeset} = assigns) do
    assigns = assign(assigns, changeset: to_form(changeset), url_link: nil)

    ~H"""
    <.form for={@changeset} class={@class} id={@id} phx-submit="generate_short_url">
      <.input field={@changeset[:long_url]} />
      <input
        class="shadow-lg border-slate-300	 bg-green-500 rounded-lg p-2 mt-2"
        type="submit"
        value="Generate Short Url"
      />
    </.form>
    """
  end

  def short_url(assigns) do
    ~H"""
    <div class="p-2 m-2">
      <a
        href={@short_url}
        id="short-url-link"
        class="underline decoration-blue-500 text-blue-500"
        target="_blank"
      >
        <%= @short_url %>
      </a>
    </div>
    """
  end
end
