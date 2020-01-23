defmodule VotrWeb.Utils do
  def get_names(nested) do
    Macro.prewalk(nested, &IO.inspect/1)
  end

  defmacro expand_all(ast) do
    quote do: unquote(__MODULE__).expand_all(unquote(ast), __ENV__)
  end

  def expand_all(ast, env), do: Macro.prewalk(ast, &Macro.expand(&1, env))

  @doc """
  Pattern-matches maps without requiring that you bind the keys to a variable
  name. Assumes atom keys. Use `ms` and `mk` for string maps and keyword lists,
  respectively.

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
  defmacro m({:%{}, ctx, args}) do
    {:%{}, ctx, Enum.map(args, &pattern/1)}
  end

  # Handle structs too.
  defmacro m({:%, ctx, args}) do
    [struct_module, {:%{}, _, _} = map] = expand_all(args, __CALLER__)

    quote do
      # Evaluate map portion as normal (by calling `m` on it).
      map = unquote(__MODULE__).m(unquote(map))
      # Create the AST for the struct; the newly evaluated map has to be escaped
      # back into AST.
      struct = {:%, unquote(ctx), [unquote(struct_module), Macro.escape(map)]}
      # Evaluate the AST into a struct.
      Code.eval_quoted(struct, binding(), __ENV__) |> elem(0)
    end
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
    for arg <- args do
      # IO.inspect arg
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
