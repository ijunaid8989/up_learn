defmodule UpLearn.Scraper.Drivers.PageTest do
  use ExUnit.Case

  import UpLearn.DriverHelpers.Page
  import Mock

  alias UpLearn
  alias UpLearn.Scraper.Drivers.Page
  alias UpLearn.Scraper.Drivers.Page.Client
  alias UpLearn.Scraper.Parser
  alias UpLearn.Scraper.Response

  setup do
    {:ok, config} =
      (driver_config().base_url <> get_data_endpoint())
      |> UpLearn.get_driver_config()

    {:ok, bypass: Bypass.open(port: 4040), config: config}
  end

  describe "get_data" do
    test "ok: provider replies with success", %{bypass: bypass, config: config} do
      Bypass.expect(bypass, "GET", get_data_endpoint(), fn conn ->
        Plug.Conn.resp(conn, 200, get_data_response())
      end)

      assert {:ok, %Response{status: "succeeded"}} = Page.get_data(config)
    end

    test "provider respond with 404 page not found", %{bypass: bypass, config: config} do
      Bypass.expect(bypass, "GET", get_data_endpoint(), fn conn ->
        Plug.Conn.resp(conn, 404, get_data_not_found_response())
      end)

      assert {:ok, %Response{status: "failed"}} = Page.get_data(config)
    end

    test_with_mock "fail: nx_domain calling Page driver for provider",
                   %{config: config},
                   Client,
                   [:passthrough],
                   get: fn _, _, _ ->
                     {:error, %HTTPoison.Error{reason: :nx_domain}}
                   end do
      assert {:error, {:unexpected_response, %HTTPoison.Error{reason: :nx_domain, id: nil}}} =
               Page.get_data(config)
    end

    test "ok: provider replies with success && fetch assets and links object", %{
      bypass: bypass,
      config: config
    } do
      Bypass.expect(bypass, "GET", get_data_endpoint(), fn conn ->
        Plug.Conn.resp(conn, 200, get_data_response())
      end)

      assert {:ok, %Response{status: "succeeded", response: %{body: body}}} =
               Page.get_data(config)

      assert {:ok, %UpLearn.ParsedDocument{}} =
               Parser.parse(body)
               |> elem(1)
               |> Parser.transform()
    end
  end
end
