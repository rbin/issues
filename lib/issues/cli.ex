defmodule Issues.CLI do
  @moduledoc """
    Handle command line parsing and dispatch of issues to various functions.
  """

  import Issues.Tabler, only: [ print_table_for_columns: 2 ]
  @default_count 4  # Create a const for default issues count.

  @doc """
    Take our args, parse them, then pass them to the `process` function.
    `Process` calls our `Issues` function to retreieve from GH & decodes response.  
  """
  def main(argv) do
    argv |> parse_args() |> process()
  end

  def process({user, project, count}) do
    Issues.fetch(user, project) 
    |> decode_response()
    |> convert_to_list_of_hashdicts()
    |> sort_into_ascending_order()
    |> Enum.take(count)
    |> print_table_for_columns(["number", "created_at", "title"])

  end

  def sort_into_ascending_order(issues_list) do
    Enum.sort issues_list,
      fn i1, i2 -> i1["created_at"] <= i2["created_at"] end
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github #{message}"
    System.halt(2)
  end

  @doc """
    Convert our JSON tuples into HashDicts for easier access to Key/Values.
  """
  def convert_to_list_of_hashdicts(list) do list
    |> Enum.map(&Enum.into(&1, HashDict.new))
  end


  @doc """
    Take a list of args, output as tuple.  Convert issues count to int.
    If no count specified, use `@default_count` const.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv)

    case parse do
      { _, [ user, project, count ], _ }
        -> { user, project, String.to_integer(count) }

      { _, [ user, project ], _ }
        -> { user, project, @default_count }  
    end
  end
  
end