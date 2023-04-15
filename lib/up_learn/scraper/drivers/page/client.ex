defmodule UpLearn.Scraper.Drivers.Page.Client do
  @moduledoc false
  use UpLearn.Scraper.Client, driver: UpLearn.Scraper.Drivers.Page

  alias UpLearn.HTTP

  ## HTTPoison.Base

  @doc false
  def process_request_body(body) when is_map(body) do
    Jason.encode!(body)
  end

  @doc false
  def process_request_body(body), do: body

  @doc false
  def process_request_headers(headers) do
    [
      {"Content-Type", "application/json"} | headers
    ]
  end

  @doc false
  def process_response_headers(headers) do
    HTTP.normalize_headers(headers)
  end

  @doc false
  def process_response_body(body) when is_binary(body) and byte_size(body) > 1 do
    HTTP.parse_body(body)
  end

  def process_response_body(_), do: %{}
end
