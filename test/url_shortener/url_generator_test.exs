defmodule UrlShortener.UrlGeneratorTest do
  use ExUnit.Case

  alias UrlShortener.{
    UrlLink,
    UrlGenerator
  }

  describe "create_short_url/1" do
    test "generate simple short url" do
      long_url = "https://www.surfline.com/surf-report/cardiff-reef/5842041f4e65fad6a77088b1"
      changeset = UrlLinks.new_url_link(long_url)

      %{changes: %{short_url: short_url}} =
        UrlGenerator.create_short_url(changeset)

      assert String.length(short_url) == 8
    end
  end
end
