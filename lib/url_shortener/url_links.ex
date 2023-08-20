defmodule UrlShortener.UrlLinks do
  alias UrlShortener.{
    LinkStore,
    UrlGenerator,
    UrlLink
  }

  def empty_changeset,
    do:
      %UrlLink{}
      |> UrlLink.changeset(%{})

  @spec new_url_link(String.t()) :: {:ok, UrlLink.t()} | {:error, String.t()}
  def new_url_link(long_url) do
    %UrlLink{}
    |> UrlLink.changeset(%{long_url: long_url})
    |> UrlGenerator.create_short_url()
    |> LinkStore.save_link()
  end
end
