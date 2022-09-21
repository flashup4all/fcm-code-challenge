defmodule FcmCodeChallengeTest do
  use ExUnit.Case
  doctest FcmCodeChallenge

  # test "greets the world" do
  #   # assert FcmCodeChallenge.hello() == :world
  # end
  test "test that file exist" do
    src = "assets/input.txt"
    assert File.exists?(src)
   assert FcmCodeChallenge.process_input(src)
  end
end
