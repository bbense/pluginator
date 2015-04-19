defmodule PluginatorTest do
  
 use ExUnit.Case, async: true

  # Due to the way Code.require_file works every test that
  # uses load should have it's own plugin. 

  test "Pluginator.search can find default test plugin" do
    assert Pluginator.search_path("test",["./test/plugins"]) == "./test/plugins/test.exs"
  end

  test "Pluginator.search fails" do
    refute Pluginator.search_path("sidehill_gouger",["./test/plugins"])
  end 
  
  test "get_modules can return a list of modules" do
    load_value = Pluginator.load("test_get_module",["./test/plugins"])
    assert Pluginator.get_modules(load_value) == [TestGM]
  end 

  test "get_functions returns a list of Tuples" do 
    mod_list = Pluginator.load("test_get_functions",["./test/plugins"]) |> Pluginator.get_modules
    assert Pluginator.get_functions(mod_list) == [{TestGF,[ success: 0 ]}]
  end

  test "match_functions" do 
    match_sig_list = [ success: 0 ]
    sig_list =  [{TestGF,[ success: 0 ]},{TestGM,[ fail: 0]}]
    assert Pluginator.match_functions(sig_list,match_sig_list) == TestGF
  end

  test "Pluginator.load returns error when plugin doesn't exist" do 
    assert Pluginator.load("sidehill_gouger",["./test/plugins"]) == {:error, :plugin_not_found}
  end

  test "Pluginator.load_with_signature finds single module file" do
    assert Pluginator.load_with_signature("test",[ success: 0 ],["./test/plugins"]) == {:ok, Test }
  end

  test "Pluginator.load_with_signature returns :sig_not_found when fails to match" do
    assert Pluginator.load_with_signature("testfail",[ sucess: 0 ],["./test/plugins"]) == {:error, :sig_not_found }
  end
end
