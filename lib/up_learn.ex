defmodule UpLearn do
  @moduledoc """
  Documentation for `UpLearn`.

  By default UpLearn will use the fetch driver but in future, we are makiing some room for drivers to be dynamic such,
  you are dealing with a page which will response us in HTML but we can just change the driver here from "page" to else based on Streaming pipelines.
  """

  import UpLearn.Scraper.Helpers

  alias Ecto.Changeset
  alias UpLearn.ParsedDocument
  alias UpLearn.Provider.Configuration
  alias UpLearn.Scraper.Parser
  alias UpLearn.Scraper.Response

  @spec fetch(binary) :: UpLearn.ParsedDocument.t()
  def fetch(url) do
    with {:ok, driver_config} <- get_driver_config(url),
         driver = module_name([UpLearn.Scraper.Drivers, "page"]),
         {:ok, %Response{response: response, status: "succeeded"}} <-
           driver.get_data(driver_config),
         {:ok, document} <- Parser.parse(response.body),
         {:ok, %ParsedDocument{} = parsed_document} <- Parser.transform(document) do
      parsed_document
    end
  end

  @spec get_driver_config(binary) :: {:ok, Configuration.t()} | {:error, Changeset.t()}
  def get_driver_config(url) do
    Configuration.new(%{base_url: url})
  end
end
