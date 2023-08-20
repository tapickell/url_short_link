defmodule UrlShortener.UrlLinksTest do
  use ExUnit.Case

  alias UrlShortener.{
    UrlLink,
    UrlLinks
  }

  describe "new_url_link/1" do
    test "with valid long_url" do
      long_url = "https://www.surfline.com/surf-report/cardiff-reef/5842041f4e65fad6a77088b1"
      assert {:ok, %UrlLink{} = url_link} = UrlLinks.new_url_link(long_url)
      assert url_link.long_url == long_url
      assert String.length(url_link.short_url_id) == 8
    end

    test "with missing scheme in long url" do
      long_url = "google.com"

      assert {:error, [long_url: {"is missing a scheme (e.g. https)", []}]} =
               UrlLinks.new_url_link(long_url)
    end
  end
end
