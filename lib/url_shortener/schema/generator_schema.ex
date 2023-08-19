defmodule UrlShortener.UrlLink do
  use Ecto.Schema
  import Ecto.Changeset

  alias UrlShortener.ValidationHelper

  @valid_fields [:long_url, :short_url_id, :last_accessed]
  @required_fields [:long_url]

  schema "url_links" do
    field(:long_url, :string)
    field(:short_url_id, :string)
    field(:last_accessed, :utc_datetime)

    timestamps()
  end

  @doc false
  def changeset(url_link, attrs) do
    url_link
    |> cast(attrs, @valid_fields)
    |> validate_required(@required_fields)
    |> validate_url(:long_url)

    # these may need to be custom to storage option
    # |> unique_constraint(:long_url)
    # |> unique_constraint(:short_url_id)
  end

  def validate_url(changeset, field, opts \\ []) do
    validate_change(changeset, field, fn _, value ->
      case ValidationHelper.check_url(value) do
        :ok -> []
        {:error, error} -> [{field, Keyword.get(opts, :message, error)}]
      end
    end)
  end
end
