defmodule UpLearn.Scraper.Parser do
  @moduledoc false

  alias UpLearn.ParsedDocument

  @spec parse(binary) :: {:ok, Floki.html_tree()} | {:error, String.t()}
  def parse(html) do
    Floki.parse_document(html)
  end

  @spec transform(Floki.html_tree()) :: {:ok, ParsedDocument.t()} | term()
  def transform(floki_document) do
    assets =
      floki_document
      |> Floki.find("img")
      |> Floki.attribute("src")
      |> Enum.filter(&(&1 != ""))

    links =
      floki_document
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> Enum.filter(&(&1 != ""))

    ParsedDocument.new(%{assets: assets, links: links})
  end
end
