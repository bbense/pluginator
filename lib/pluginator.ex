defmodule Pluginator do
  @moduledoc """
    Utility routines for loading plugin modules. Given plugin = foo, it looks
    in the search path for a file called foo.exs 
  """

  @doc """
    load_with_signature("plugin_name",function_signature,load_paths)
    returns the module loaded from "plugin_name" that implements all
    the functions in the signature. 
  """
  def load_with_signature(plugin,signature,paths) do 
    status = load(plugin,paths)
    case status do
      nil -> {:error, :plugin_already_loaded}
      {:error, :plugin_not_found} -> status
      _   -> find_signature(status,signature)
    end
  end 

  defp find_signature(status,signature) do
    match = status 
    |>
     get_modules
    |>
     get_functions
    |>
      match_functions(signature)

    case match do
      nil -> {:error, :sig_not_found }
      _   -> {:ok, match}
    end

  end 

  @doc """
     load("plugin_name",load_paths) searches the load path list of directories
     for a plugin file with the name "plugin_name.exs". It returns the result of Code.require_file
     if found, otherwise {:error, :plugin_not_found }
  """
  def load(plugin,paths) do
    path = search_path(plugin,paths)
    case path do
      nil -> { :error, :plugin_not_found }
      _   -> Code.require_file(path) 
    end 
  end
 
  @doc """ 
      get_modules takes the result of a load and returns a 
      list of the modules that have been defined by the load. 
  """
  def get_modules(load_list) do 
    load_list |> Enum.map( fn(m) -> elem(m,0) end )
  end 

  @doc """ 
      get_functions takes a 
      list of the modules and returns a list of tuples with module_names and functions
  """
  def get_functions(mod_list) do 
    mod_list |> Enum.map( fn(m) -> {m, m.__info__(:functions)} end )
  end 
  
  @doc """
      match_functions takes a list of modules and function tuples and returns
      the first one that matchs the function signature list. If no function signature
      matches it returns nil.  
  """
  def match_functions(mod_sig_list,match_sig) do 
    match = mod_sig_list |> Enum.find( fn({_,sig}) -> contains(sig,match_sig) end )
    case match do
      nil -> nil
      _   -> elem(match,0)
    end     
  end 

 
  #contains returns true if sig has all the elements of match_sig
  defp contains(sig,match_sig) do
    found = match_sig|> Enum.map(fn(test_sig) -> Enum.find(sig, fn(x) -> x == test_sig end) end) 
    found == match_sig
  end 

  def search_path(plugin,paths) do
    target = "#{plugin}.exs"
     paths
    |>
     Enum.flat_map( fn(dir) -> entries(dir) end )
    |>
     Enum.filter( fn(file) -> Path.basename(file) == target end)
    |>
     List.first
  end 


  defp entries(dir) do
    {:ok,elist} = File.ls(dir)
    Enum.map(elist, fn(entry) -> "#{dir}/#{entry}" end)
  end 

end
