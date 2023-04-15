defmodule UpLearn.DriverHelpers.Page do
  @moduledoc false

  def driver_config do
    %{
      base_url: "http://localhost:4040",
      ext: %{
        http_options: %{
          timeout: 5_000,
          recv_timeout: 10_000
        }
      }
    }
  end

  def get_data_endpoint, do: "/api/some-good-html"

  @html_with_data_attributes """
  <html>
  <head>
  <title>Test</title>
  </head>
  <body>
    <div class="content">
      <a href="http://google.com" class="js-google js-cool" data-action="lolcats">Google</a>
      <a href="http://elixir-lang.org" class="js-elixir js-cool">Elixir lang</a>
      <a href="http://java.com" class="js-java">Java</a>
      <a href="http://twitter.com">
        <img src="http://twitter.com/logo.png" class="js-twitter-logo" />
      </a>
      <!-- this is a comment -->
    </div>
  <div class="logo-container">
    <img src="http://twitter.com/logo.png" class="img-without-closing-tag">
    <img src="logo.png" id="logo" />
  </div>
  </body>
  </html>
  """

  @html_with_404_not_found """
  <h1>Page not found</h1>
  """

  def get_data_response do
    @html_with_data_attributes
    |> Jason.encode!()
  end

  def get_data_not_found_response do
    @html_with_404_not_found
    |> Jason.encode!()
  end
end
