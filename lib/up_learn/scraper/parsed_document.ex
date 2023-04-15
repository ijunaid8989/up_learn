defmodule UpLearn.ParsedDocument do
  @moduledoc """
  Represents the formated shape of API response.
  """

  use Ecto.Schema

  import Ecto.Changeset
  alias Ecto.Changeset

  @type t :: %__MODULE__{}

  @fields [
    :assets,
    :links
  ]

  @derive Jason.Encoder
  @primary_key false
  embedded_schema do
    field(:assets, {:array, :string})
    field(:links, {:array, :string})
  end

  @spec new(map) :: {:ok, t()} | {:error, Changeset.t()}
  def new(attrs) when is_map(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> case do
      changeset = %Changeset{valid?: true} -> {:ok, apply_changes(changeset)}
      changeset -> {:error, changeset}
    end
  end
end
