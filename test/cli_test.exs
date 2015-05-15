defmodule CliTest do
  use ExUnit.Case

  import Issues.CLI, only: [ parse_args: 1 ]

  test "three values returned if three given" do
  	assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two values given" do
  	assert parse_args(["user", "project"]) == {"user", "project", 4}
  end
  
end
