defmodule UpLearn.Scraper.Driver do
  @moduledoc """
  Main Driver Interface.
  """

  @typedoc "Scrapper request response"
  @type response ::
          {:ok, UpLearn.Scraper.Response.t()}
          | {:error, {:unexpected_response, UpLearn.Scraper.Response.t()}}
          | {:error, term}

  @doc false
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @behaviour UpLearn.Scraper.Driver

      import UpLearn.Scraper.Helpers

      @name opts[:name] || raise(ArgumentError, "expected name: to be given as argument")

      @doc false
      def fetch_in!(data, keys) do
        get_in(data, keys) || raise(KeyError, key: keys, term: @name)
      end

      @doc false
      def dispatch_driver_event(event, meta \\ %{}) do
        IO.inspect(event)

        :telemetry.execute(
          [:driver | event],
          %{count: 1},
          Map.merge(meta, %{name: @name})
        )
      end

      @doc false
      def http_otps(config) do
        [
          timeout: 10_000,
          recv_timeout: 15_000,
          ssl: [{:versions, [:"tlsv1.2"]}]
        ]
        |> Keyword.merge(:maps.to_list(config.ext[:http_options] || %{}))
        |> IO.inspect()
      end
    end
  end
end
