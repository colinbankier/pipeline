defmodule Pipeline.ApiDriver do
  use HTTPoison.Base

  def process_url(url) do
    "http://localhost:4000/" <> url
  end

  def process_response_body(body) do
    IO.inspect body
    JSX.decode! body
  end

  def process_request_body(body) do
    IO.inspect body
    json = JSX.encode! body
    IO.inspect json
    json
  end
end
