defmodule Issues.Cli do
  @default_count 4
  @columns_for_display ["number", "created_at", "title"]
  
  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def main(argv) do
    argv
    |>parse_args
    |>process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.
  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:     :help  ])
    case parse do
      { [ help: true ], _, _ }           -> :help
      { _, [ user, project, count ], _ } -> { user, project, String.to_integer(count) }
      { _, [ user, project ], _ }        -> { user, project, @default_count }
      _                                  -> :help
    end
  end
  
  def process( :help ) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end
  
  def process({ user, project, count }) do
    Issues.GithubIssues.fetch(user, project)
    |>check_response
    |>sort_data
    |>Enum.take(count)
    |>Issues.TableFormatter.display_result(@columns_for_display)
  end
  
  defp check_response({ :ok, body }), do: body
  defp check_response({ :error, body }) do
    message = body["message"]
    IO.puts "Error while fetching data from GitHub: #{message}"
    System.halt(2)
  end
  
  defp sort_data(issues) do
    issues|>Enum.sort(&(&1["created_at"] <= &2["created_at"]))
  end
end