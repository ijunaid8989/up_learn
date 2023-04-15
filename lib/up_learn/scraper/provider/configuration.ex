defmodule UpLearn.Provider.Configuration do
  @moduledoc """
  Provider's configuration.
  """

  use Ecto.Schema

  import Ecto.Changeset
  alias Ecto.Changeset

  @type t :: %__MODULE__{}

  @fields [
    :base_url,
    :ext
  ]

  @can_skip_validation [:ext]

  @derive Jason.Encoder
  @primary_key false
  embedded_schema do
    field(:base_url, :string)
    field(:ext, :map, default: %{})
  end

  @spec new(map) :: {:ok, t()} | {:error, Changeset.t()}
  def new(attrs) when is_map(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields -- @can_skip_validation)
    |> validate_url(:base_url)
    |> case do
      changeset = %Changeset{valid?: true} -> {:ok, apply_changes(changeset)}
      changeset -> {:error, changeset}
    end
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn _, value ->
      case URI.parse(value) do
        %URI{scheme: scheme, host: host} when is_nil(scheme) or is_nil(host) ->
          [{field, "invalid url"}]

        %URI{} ->
          []
      end
    end)
  end
end
