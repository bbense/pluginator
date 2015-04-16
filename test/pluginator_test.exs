defmodule PluginatorTest do
  
 use ExUnit.Case, async: true

  
  test "Pluginator.get_paths returns a list of dirs" do
    assert Pluginator.get_paths == ["./test/plugins"]
  end

  test "Pluginator.search can find default test plugin" do
    assert Pluginator.search_path("test") == "./test/plugins/test.exs"
  end

  test "Pluginator.search fails" do
    refute Pluginator.search_path("sidehill_gouger")
  end 
  
  # Does not pass for some reason. Error is raised. 
  test "Pluginator.load raises error when plugin doesn't exist" do 
     assert_raise RuntimeError, fn -> Pluginator.load("sidehill_gouger") end
  end

  test "Pluginator.load" do
    Pluginator.load("test")
  end

end
