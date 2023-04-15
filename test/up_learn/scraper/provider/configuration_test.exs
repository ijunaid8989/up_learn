defmodule UpLearn.Provider.ConfigurationTest do
  use ExUnit.Case

  import UpLearn.TestUtils

  alias UpLearn.Provider.Configuration

  describe "new/1" do
    test "return ok and a valid Configuration" do
      attrs = %{
        base_url: "http://localhost:3000",
        ext: %{
          http_options: %{
            timeout: 5_000,
            recv_timeout: 10_000
          }
        }
      }

      assert {:ok, %Configuration{}} = Configuration.new(attrs)
    end

    test "return an invalid changeset with proper errors" do
      assert {:error, changeset} = Configuration.new(%{})

      assert errors_on(changeset) == %{base_url: ["can't be blank"]}
    end
  end
end
