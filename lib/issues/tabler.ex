defmodule Issues.Tabler do
  @moduledoc """
    Take our HashDict Key/Values and map them into a SQL-esque display table.
    `Tabler` is passed a list of columns to be printed and writes them to `:stdio`.
  """

  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  @doc """
    Called from our main `process()`, this calls all the module functions to build the Table.
  """
  def print_table_for_columns(rows, headers) do
    data_by_columns = split_into_columns(rows, headers)
    column_widths   = widths_of(data_by_columns)
    format          = format_for(column_widths)

    puts_one_line_in_columns(headers, format)
    IO.puts separator(column_widths)
    puts_in_columns(data_by_columns, format)
  end

  @doc """
    Splits our data into columns with each `row` and it's `header`.
  """
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  @doc """
    Convert rows to strings if not in `printable` format.
  """
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  @doc """
    Make the columns the width of the data being piped in.
  """
  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end

  @doc """
    Create the column layout formatters & separators.
  """
  def format_for(column_widths) do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  @doc """
    This function pipes the data into columns after converting Tuples into lists.
  """
  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end

end