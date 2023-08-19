defmodule UrlShortener.ValidationHelperTest do
  use ExUnit.Case

  alias UrlShortener.ValidationHelper

  describe "check_url/1" do
    test "valid url" do
      valid_url = "https://google.com"
      assert :ok == ValidationHelper.check_url(valid_url)
    end

    test "missing scheme" do
      assert {:error, "is missing a scheme (e.g. https)"} ==
               ValidationHelper.check_url("google.com")
    end

    test "missing host" do
      assert {:error, "is missing a host"} == ValidationHelper.check_url("https://nope@:42")
    end

    test "invalid host" do
      assert {:error, "invalid host"} ==
               ValidationHelper.check_url("https://made-this-up.nope")
    end
  end
end
