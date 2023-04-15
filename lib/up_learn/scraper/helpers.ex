defmodule UpLearn.Scraper.Helpers do
  @moduledoc false

  ## API

  @spec module_name([binary]) :: module
  def module_name(list) do
    list
    |> Enum.map(&Macro.camelize(to_string(&1)))
    |> Module.concat()
  end
end
