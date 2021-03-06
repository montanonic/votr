defmodule VotrWeb.Utils do
  def get_names(nested) do
    Macro.prewalk(nested, &IO.inspect/1)
  end

  defmacro expand_all(ast) do
    quote do: unquote(__MODULE__).expand_all(unquote(ast), __ENV__)
  end

  def expand_all(ast, env), do: Macro.prewalk(ast, &Macro.expand(&1, env))

  @doc """
  Pattern-matches maps/structs without requiring that you bind the keys to a
  variable name, converting un-keyed variables into atom keys like so:

  So `m(%{x})` becomes `%{x: x}`; `m(%User{name})` becomes `%User{name: name}`.

  If you want un-keyed variables to be converted into string keys, use `ms`.
  Finally, use `mk` if you want your output to be a keyword list, but it
  otherwise functions indentically to this macro.

  Note that you can still use `"blah" => "rah"` syntax to write arbitrary keys:

      m(%{"yes" => x, x}) # Becomes `%{"yes" => x, x: x}`

  ## Limitations

  This macro attempts to work as seamlessly as it can wherever a map is used,
  but there are some points of friction. First, you must remember to call it
  inside of parenthesis like so:

      def thing(m(%{hey, you})), do: [hey, you]

  since `m` is just treated like a function call on its argument `%{...}`, which
  must be a map.

  The second limitation is that you can bind to custom variables as usual using
  `%{x: y}` syntax, but any such bindings must all come _after_ the
  single-variable syntax of `%{x, y, z}` supported by this macro. `%{x: y, z}`
  is invalid, for example, but `%{z, x: y}` will work fine.

  Beyond this, all other map construction and matching operations natively
  supported by elixir should work correctly. The one (known) exception to this
  is map update syntax, which is incompatible and not really a good fit.

  ## Examples:
      iex> m(%{you}) = %{hey: 10, you: "there"}
      %{hey: 10, you: "there"}
      iex> you
      "there"

      iex> m(%{x, y: z}) = %{x: 42, y: 99}
      %{x: 42, y: 99}
      iex> x
      42
      iex> z
      99
  """
  defmacro m({:%{}, _, _} = ast), do: handle_m(ast)

  defmacro m({:%, _, _} = ast), do: handle_m(ast)

  # Implements rewriting single map atoms to key-values.
  #
  # Example: `%{x}` becomes %{x: x}`.
  defp handle_m({:%{}, ctx, args}) do
    {:%{}, ctx, Enum.map(args, &pattern/1)}
  end

  # Handle structs too.
  defp handle_m({:%, ctx, args}) do
    # `%` takes two arguments. Assuming `User` is a struct, a cal would look
    # like: `%User{}`. You'll notice that writing `%User {}` and `% User {}`
    # also works; as a point of interest, if `%` was a normal macro, you'd have
    # to write `% User, {}`, but this shows that it's not. In any case, `%`
    # receives two arguments, the module for the struct, and the initial struct
    # mapping (or blank map). This destructuring below extracts those values
    # out. The AST of a `%` call interprets `{}` as `%{}`, which we pattern
    # match on here.
    [struct_module, {:%{}, _, _} = map_ast] = args

    # Handle the map portion the same as `m({:%{}, ... })` does, passing
    # everything else through unmodfied.
    {:%, ctx, [struct_module, handle_m(map_ast)]}
  end

  @doc """
  Like the `m` macro, but treats any given atom keys as string keys.

  ## Example:
      iex> x = "one"; y = 42
      42
      iex> ms(%{x, y})
      %{"x" => "one", "y" => 42}
  """
  defmacro ms({:%{}, ctx, args}) do
    {:%{}, ctx, Enum.map(args, &pattern_s/1)}
  end

  @doc """
  Like the `m` macro, but yields a keyword map.
  """
  defmacro mk({:%{}, _ctx, args}) do
    # The AST for keyword maps consists of literal values, so as long as
    # `pattern` only returns 2-tuples, this simple `for` is sufficient to return
    # the complete AST.
    for arg <- args do
      pattern(arg)
    end
  end

  defp pattern(term) do
    case term do
      {key, _, _} = variable -> {key, variable}
      other -> other
    end
  end

  defp pattern_s(term) do
    case term do
      {key, _, _} = variable -> {Atom.to_string(key), variable}
      {key, value} -> {Atom.to_string(key), value}
      other -> other
    end
  end
end
