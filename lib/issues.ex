defmodule Issues do
  @moduledoc """
    Handle HTTP GET request to Github API for issues. 
  """
  require Logger

  @user_agent [{"User-agent", "Elixir me@rbin.co"}]   # Keep the GitHub API happy with a UAgent const.
  @github_url Application.get_env(:issues, :github_url)   # Get github url from config at compile time.


  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  @doc """
    Dispatch Get request to `issues_url`, and pipe response to our `handle_response` func.
  """
  def fetch(user, project) do
    Logger.info "Fetching user #{user}'s project: #{project}"
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  @doc """
    Handle the response from GET request depending on HTTP statuscode.  Return `:status, body` tuple.
  """
  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end
    {:ok, :jsx.decode(body)}
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
    {:error, :jsx.decode(body)}
  end

  def handle_response({:error, body}) do
    {:error, :jsx.decode(body)}
  end

end