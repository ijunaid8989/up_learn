defmodule UpLearn.Provider.Configuration do
  @moduledoc """
  Provider's configuration.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @fields [
    :base_url,
    :ext
  ]

  @derive Jason.Encoder
  @primary_key false
  embedded_schema do
    field(:base_url, :string)
    field(:ext, :map, default: %{})
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(t, attrs) do
    t
    |> cast(attrs, @fields)
    |> validate_required([:base_url])
    |> validate_url(:base_url)
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
