defmodule UpLearn.TestUtils do
  @moduledoc false

  import ExUnit.Assertions

  alias Ecto.Changeset

  def errors_on(changeset) do
    Changeset.traverse_errors(
      changeset,
      fn {message, opts} ->
        Enum.reduce(
          opts,
          message,
          fn {key, value}, acc ->
            String.replace(acc, "%{#{key}}", to_string(value))
          end
        )
      end
    )
  end
end
