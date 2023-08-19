defmodule UrlShortener.LinkStore do
  # Store both indexes of short_url_id and long_url
  # Store can be checked for existing long_url
  # if exists return short_url_id
  # Store can be checked for existing short_url_id
  # if exists return long_url
  # if neither exist store both
  use Agent

  alias UrlShortener.UrlLink

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def get_link(short_url_id) do
    Agent.get(__MODULE__, & &1)
    |> Map.get(short_url_id)
  end

  def save_link(%UrlLink{errors: []} = url_link) do
    store = Agent.get(__MODULE__, & &1)

    if not url_link_exists?(store, url_link) do
      Agent.update(__MODULE__, fn store ->
        store_new_url_lnk(store, url_link)
      end)
    end
  end
  def save_link(%UrlLink{} = url_link) do

  def url_link_exists?(store, url_link) do
    Map.has_key?(url_link.long_url) || Map.has_key?(url_link.short_url_id)
  end

  def store_new_url_lnk(store, url_link) do
    store
    |> Map.put(url_link.short_url_id, url_link)
    |> Map.put(url_link.long_url, url_link)
  end
end
