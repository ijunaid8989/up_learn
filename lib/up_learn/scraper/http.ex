defmodule UpLearn.HTTP do
  @moduledoc """
  HTTP Utils.

  we can define the authentication methods here in case the HTTP request need any auth such as basic / digest
  """

  require Logger

  @type header :: {binary, binary}

  ## API

  @doc false
  @spec parse_body(binary) :: term
  def parse_body(json) do
    case Jason.decode(json) do
      {:ok, parsed_json} ->
        parsed_json

      {:error, reason} ->
        :ok = Logger.debug(fn -> "error parsing json: #{inspect(reason)}" end)
        json
    end
  end

  @doc false
  @spec normalize_headers(HTTPoison.headers()) :: HTTPoison.headers()
  def normalize_headers(headers) do
    for {name, value} <- headers do
      {String.downcase(name), value}
    end
  end
end
