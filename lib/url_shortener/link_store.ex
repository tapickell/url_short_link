defmodule UrlShortener.LinkStore do
  # Store both indexes of short_url_id and long_url
  # Store can be checked for existing long_url
  # if exists return short_url_id
  # Store can be checked for existing short_url_id
  # if exists return long_url
  # if neither exist store both
  use Agent

  require Logger

  alias UrlShortener.UrlLink

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def get_link(url_key) do
    Agent.get(__MODULE__, & &1)
    |> Map.get(url_key)
  end

  def save_link(%Ecto.Changeset{errors: []} = url_link_changeset) do
    %UrlLink{long_url: long_url} =
      url_link = Ecto.Changeset.apply_changes(url_link_changeset)

    store = Agent.get(__MODULE__, & &1)

    case Map.get(store, long_url) do
      %UrlLink{} = long_link ->
        log_store_state(:long_link_found)
        {:ok, long_link}

      nil ->
        Agent.update(__MODULE__, fn store ->
          store_new_url_lnk(store, url_link)
        end)

        log_store_state(:new_link_inserted)
        {:ok, url_link}
    end
  end

  def save_link(%{errors: errors, valid?: false}) do
    {:error, errors}
  end

  def log_store_state(info_term) do
    store = Agent.get(__MODULE__, & &1)
    Logger.info("#{__MODULE__} #{info_term}: " <> inspect(store))
  end

  defp store_new_url_lnk(store, url_link) do
    store
    |> Map.put(url_link.short_url_id, url_link)
    |> Map.put(url_link.long_url, url_link)
  end
end
