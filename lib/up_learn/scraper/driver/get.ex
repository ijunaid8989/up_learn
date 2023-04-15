defmodule UpLearn.Scraper.Driver.Get do
  @moduledoc """
  Fetch Driver.
  """

  alias UpLearn.Scraper.Driver

  @typedoc "Configuration type"
  @type driver_config :: UpLearn.Provider.Configuration.t()

  @doc """
  Fetches data from provider URL.
  """
  @callback get_data(driver_config) :: Driver.response()
end
