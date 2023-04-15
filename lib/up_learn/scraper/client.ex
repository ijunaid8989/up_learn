defmodule UpLearn.Scraper.Client do
  @moduledoc false

  @doc false
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      use HTTPoison.Base
      require Logger

      @driver opts[:driver] || raise(ArgumentError, "expected driver: to be given as argument")

      @doc false
      def process_response_status_code(status) when status >= 500 and status <= 599 do
        # We can introduce rate limiting here for future. I am leaving some here to log for just
        # now but this part should deal the rate limiting and throttle counter.
        # and @driver will be used to identifiy the driver for which requests are going to be limited or monitored now.
        :ok = Logger.debug(fn -> "error making http request: #{inspect(status)}" end)
        status
      end

      def process_response_status_code(status) do
        status
      end
    end
  end
end
