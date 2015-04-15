defmodule Pluginator do
  @moduledoc """
    Utility routines for loading plugin modules. Given plugin = foo, it looks
    in the search path for a file called foo.exs 
  """

  def load(plugin) do
    path = search_path(plugin)
    unless( path, do: raise "#{plugin} not found")
    Code.require_file(path) 
  end
 
  def search_path(plugin) do
    target = "#{plugin}.exs"
     get_paths
    |>
     Enum.flat_map( fn(dir) -> entries(dir) end )
    |>
     Enum.filter( fn(file) -> Path.basename(file) == target end)
    |>
     List.first
  end 

  @doc """
    set_path is currently a noop placeholder.
  """
  def set_path(path) do
    path
  end 

  def get_paths do
     ["./test/plugins"]
  end 

  defp entries(dir) do
    {:ok,elist} = File.ls(dir)
    Enum.map(elist, fn(entry) -> "#{dir}/#{entry}" end)
  end 

end
