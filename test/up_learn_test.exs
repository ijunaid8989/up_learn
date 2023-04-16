defmodule UpLearnTest do
  use ExUnit.Case

  import UpLearn.DriverHelpers.Page
  import UpLearn.TestUtils

  alias UpLearn

  setup do
    {:ok, config} =
      (driver_config().base_url <> get_data_endpoint())
      |> UpLearn.get_driver_config()

    {:ok, bypass: Bypass.open(port: 4040), config: config}
  end

  describe "fetch/1" do
    test "ok: fetch  success", %{bypass: bypass, config: config} do
      Bypass.expect(bypass, "GET", get_data_endpoint(), fn conn ->
        Plug.Conn.resp(conn, 200, get_data_response())
      end)

      assert %UpLearn.ParsedDocument{assets: assets, links: links} =
               UpLearn.fetch(config.base_url)

      assert length(assets) == 3
      assert length(links) == 4
    end

    test "error: fetch failed due to invalid URL" do
      assert {:error, changeset} = UpLearn.fetch("invalid url")
      assert errors_on(changeset) == %{base_url: ["invalid url"]}
    end

    test "error: fetch failed due to nx domain" do
      {:error, {:unexpected_response, %HTTPoison.Error{reason: :nxdomain, id: nil}}} =
        UpLearn.fetch("https://dot.com.d")
    end
  end
end
