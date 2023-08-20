defmodule UrlShortenerWeb.RedirectionController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.LinkStore

  def go(conn, %{"short_url" => short_url_id}) do
    case LinkStore.get_link(short_url_id) do
      nil ->
        send_resp(conn, 404, "Nope")

      url_link ->
        redirect(conn, external: url_link.long_url)
    end
  end
end
