defmodule Issues.CLI do

	@default_count 4	# Create a const for default issues count.

	@moduledoc """
		Handle command line parsing and dispatch of issues to various functions.
	"""

	@doc """
		Take our args, parse them, then pass them to the `process` function.
		`Process` calls our `Issues` function to retreieve from GH & decodes response.	
	"""
	def run(argv) do
		argv |> parse_args() |> process()
	end

	def process({user, project, _count}) do
		Issues.fetch(user, project) 
		|> decode_response()
	end

	def decode_response({:ok, body}), do: body

	def decode_response({:error, error}) do
		{_, message} = List.keyfind(error, "message", 0)
		IO.puts "Error fetching from Github #{message}"
		System.halt(2)
	end

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