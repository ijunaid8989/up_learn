defmodule UpLearn.Scraper.Drivers.Page do
  @moduledoc """
  Implementation for Fetching data from URL.
  """

  # Implemented behaviours
  @behaviour UpLearn.Scraper.Driver.Get

  # Inherited base behaviour
  use UpLearn.Scraper.Driver, name: :page

  alias UpLearn.Scraper.{Drivers.Page.Client, Response}

  require Logger

  @type driver_config :: UpLearn.Provider.Configuration.t()

  @succeeded_response_status [200]

  @impl true
  def get_data(%{base_url: base_url} = config) do
    case Client.get(base_url, [], http_otps(config)) do
      {:ok, response} ->
        status = get_status_from_response(response)
        :ok = dispatch_info(status, response.body)
        {:ok, Response.new(response, status)}

      {:error, response} ->
        status = get_status_from_response(response)
        :ok = dispatch_info(status, response.reason)
        {:error, {:unexpected_response, response}}
    end
  end

  ## Private functions

  defp dispatch_info(status, response) do
    dispatch_driver_event(
      [:fetch, :status],
      %{
        body: response,
        status: status
      }
    )
  end

  defp get_status_from_response(%HTTPoison.Response{status_code: resp_code})
       when resp_code in @succeeded_response_status,
       do: "succeeded"

  defp get_status_from_response(_), do: "failed"
end
