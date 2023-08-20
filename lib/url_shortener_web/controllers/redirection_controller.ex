defmodule UrlShortenerWeb.RedirectionController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.LinkStore

  def go(conn, %{"short_url" => short_url_id}) do
    case LinkStore.get_link(short_url_id) do
      nil ->
        render(conn, "404.html")

      url_link ->
        redirect(conn, external: url_link.long_url)
    end
  end
end
