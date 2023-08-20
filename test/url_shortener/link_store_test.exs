defmodule UrlShortener.LinkStoreTest do
  use ExUnit.Case

  alias UrlShortener.{
    LinkStore,
    UrlLink,
    UrlGenerator
  }

  def setup do
    {:ok, _pid} = LinkStore.start_link()
    :ok
  end

  defp reset_agent do
    Agent.update(LinkStore, fn _store ->
      %{}
    end)
  end

  describe "get_link/1" do
    test "with link in store" do
      short_url_id = "asdf1234"
      Agent.update(LinkStore, fn store -> Map.put(store, short_url_id, "long_url") end)

      assert LinkStore.get_link(short_url_id) == "long_url"
      reset_agent()
    end

    test "missing link in store" do
      short_url_id = "asdf1234"

      assert LinkStore.get_link(short_url_id) == nil
      reset_agent()
    end
  end

  describe "save_link/1" do
    test "saves a valid link" do
      long_url = "https://www.surfline.com/surf-report/cardiff-reef/5842041f4e65fad6a77088b1"

      changeset =
        %UrlLink{}
        |> UrlLink.changeset(%{long_url: long_url})
        |> UrlGenerator.create_short_url()

      assert {:ok, url_link} = LinkStore.save_link(changeset)
      assert url_link.long_url == long_url
      reset_agent()
    end

    test "save is idempotent on long_url" do
      long_url = "https://www.surfline.com/surf-report/cardiff-reef/5842041f4e65fad6a77088b1"
      Agent.update(LinkStore, fn store -> Map.put(store, long_url, "short_url_id") end)

      changeset =
        %UrlLink{}
        |> UrlLink.changeset(%{long_url: long_url})
        |> UrlGenerator.create_short_url()

      assert {:ok, url_link} = LinkStore.save_link(changeset)
      assert url_link.long_url == long_url
      assert Agent.get(LinkStore, & &1) == %{long_url => "short_url_id"}
      reset_agent()
    end

    test "save is idempotent on short_url_id" do
      long_url = "https://www.surfline.com/surf-report/cardiff-reef/5842041f4e65fad6a77088b1"

      changeset =
        %UrlLink{}
        |> UrlLink.changeset(%{long_url: long_url})
        |> UrlGenerator.create_short_url()

      short_url_id = changeset.changes.short_url_id
      Agent.update(LinkStore, fn store -> Map.put(store, short_url_id, long_url) end)

      assert {:ok, url_link} = LinkStore.save_link(changeset)
      assert url_link.long_url == long_url
      assert Agent.get(LinkStore, & &1) == %{short_url_id => long_url}
      reset_agent()
    end

    test "does not save an invalid link" do
      long_url = "www.surfline.com/surf-report/cardiff-reef/5842041f4e65fad6a77088b1"

      changeset =
        %UrlLink{}
        |> UrlLink.changeset(%{long_url: long_url})
        |> UrlGenerator.create_short_url()

      assert {:error, [long_url: {"is missing a scheme (e.g. https)", []}]} ==
               LinkStore.save_link(changeset)

      reset_agent()
    end
  end
end
