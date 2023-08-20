import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :url_shortener, UrlShortenerWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  url: [scheme: "https", host: "warm-refuge-24772-0d08b4eef0a1.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: UrlShortener.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
