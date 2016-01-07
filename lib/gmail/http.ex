defmodule Gmail.HTTP do

  @moduledoc """
  HTTP request handling.
  """

  @doc """
  Performs an HTTP POST request.
  """
  @spec post(String.t, String.t, Map.t) :: {:ok, Map.t}
  def post(token, url, data) do
    headers = get_headers(token)
    {:ok, json} = Poison.encode(data)
    {:ok, response} = HTTPoison.post(url, json, headers)
    {:ok, parse_body(response)}
  end

  @doc """
  Performs an HTTP PUT request.
  """
  @spec put(String.t, String.t, Map.t) :: {:ok, Map.t}
  def put(token, url, data) do
    headers = get_headers(token)
    {:ok, json} = Poison.encode(data)
    {:ok, response} = HTTPoison.put(url, json, headers)
    {:ok, parse_body(response)}
  end

  @doc """
  Performs an HTTP GET request.
  """
  @spec get(String.t, String.t) :: {:ok, Map.t}
  def get(token, url) do
    headers = get_headers(token)
    {:ok, response} = HTTPoison.get(url, headers)
    {:ok, parse_body(response)}
  end

  @doc """
  Performs an HTTP DELETE request.
  """
  @spec delete(String.t, String.t) :: {:ok, Map.t}
  def delete(token, url) do
    headers = get_headers(token)
    {:ok, response} = HTTPoison.delete(url, headers)
    {:ok, parse_body(response)}
  end

  @spec parse_body(HTTPoison.Response.t) :: {:ok, Map.t}
  defp parse_body(%HTTPoison.Response{body: body}) do
    # case Poison.Parser.parse(body) do
    case Poison.decode(body) do
      {:ok, body} -> body
      {:error, _error} -> nil
    end
  end

  defp get_headers(token) do
    [
      {"Authorization", "Bearer #{token}"},
      {"Content-Type", "application/json"}
    ]
  end

end
