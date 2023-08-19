defmodule UrlShortener.UrlGenerator do
  alias UrlShortener.UrlLink

  def create_short_url(%Ecto.Changeset{errors: []} = changeset) do
    UrlLink.changeset(changeset, %{short_url: short_url_id()})
  end

  def create_short_url(changeset), do: changeset

  defp short_url_id do
    Ecto.UUID.generate()
    |> String.slice(0..7)
  end
end
