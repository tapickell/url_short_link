defmodule UrlShortener.UrlGenerator do
  def create_short_url(%Ecto.Changeset{errors: []} = changeset) do
    Ecto.Changeset.put_change(changeset, :short_url_id, short_url_id())
  end

  def create_short_url(changeset), do: changeset

  defp short_url_id do
    Ecto.UUID.generate()
    |> String.slice(0..7)
  end
end
