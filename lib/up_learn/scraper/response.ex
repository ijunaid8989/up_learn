defmodule UpLearn.Scraper.Response do
  @moduledoc """
  Scrapper Request response.
  """

  require Logger

  @derive Jason.Encoder
  defstruct status: nil, response: nil

  @typedoc "Scrapper Request response type"
  @type t :: %__MODULE__{
          status: binary | nil,
          response: map | nil
        }

  ## API

  @spec new(term | nil, binary | nil) :: t
  def new(response \\ nil, status \\ nil) do
    %__MODULE__{
      status: status,
      response: build_response(response)
    }
  end

  ## Private Functions

  defp build_response(%HTTPoison.Response{} = response) do
    Map.take(response, [:status_code, :request_url, :body])
  end

  defp build_response(response) do
    inspect(response)
  end
end
