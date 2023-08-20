defmodule UrlShortener.LinkStore do
  # Store both indexes of short_url_id and long_url
  # Store can be checked for existing long_url
  # if exists return short_url_id
  # Store can be checked for existing short_url_id
  # if exists return long_url
  # if neither exist store both
  use Agent

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def get_link(short_url_id) do
    Agent.get(__MODULE__, & &1)
    |> Map.get(short_url_id)
  end

  def save_link(%Ecto.Changeset{errors: []} = url_link_changeset) do
    url_link = Ecto.Changeset.apply_changes(url_link_changeset)
    store = Agent.get(__MODULE__, & &1)

    if not url_link_exists?(store, url_link) do
      Agent.update(__MODULE__, fn store ->
        store_new_url_lnk(store, url_link)
      end)
    end

    {:ok, url_link}
  end

  def save_link(%{errors: errors, valid?: false}) do
    {:error, errors}
  end

  defp url_link_exists?(store, url_link) do
    Map.has_key?(store, url_link.short_url_id) ||
      Map.has_key?(store, url_link.long_url)
  end

  defp store_new_url_lnk(store, url_link) do
    store
    |> Map.put(url_link.short_url_id, url_link)
    |> Map.put(url_link.long_url, url_link)
  end
end
