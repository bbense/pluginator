# pluginator
Elixir library for managing plugins

Utility routines for loading plugin modules. Given plugin = foo, it looks
in the search path for a file called foo.exs 
 

The primary function is Pluginator.load_with_signature

    load_with_signature("plugin_name",function_signature,load_paths)
    returns the first module loaded from "plugin_name" that implements all
    the functions in the signature. It returns one of four tuples

    {:ok, Module}
    {:error, :plugin_already_loaded}
    {:error, :plugin_not_found}
    {:error, :sig_not_found}

    The signature should be exactly the same format as the return value of
    Module.__info__(:functions)

    ## Examples

      > {:ok, truth } = Pluginator.load_with_signature("truth",[success: 0, failure: 0],"path/to/plugins")
      truth.success
