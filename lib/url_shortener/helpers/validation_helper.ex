defmodule UrlShortener.ValidationHelper do
  @spec(check_url(String.t()) :: :ok, {:error, String.t()})
  def check_url(value) do
    case URI.parse(value) do
      %URI{scheme: nil} -> {:error, "is missing a scheme (e.g. https)"}
      %URI{host: nil} -> {:error, "is missing a host"}
      %URI{host: host} -> validate_host(host)
    end
  end

  defp validate_host(host) do
    case :inet.gethostbyname(Kernel.to_charlist(host)) do
      {:ok, _} -> :ok
      {:error, _} -> {:error, "invalid host"}
    end
  end
end
