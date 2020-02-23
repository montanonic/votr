_ = """
Match binding in function heads works on either side, so:
"""

defmodule MatchBindingInFunctions do
  def val, do: %{tuti: %{fruit: "banana", calories: 345}}

  def lhs(%{tuti: frooti = %{fruit: fruit}}), do: [frooti, fruit]
  def rhs(%{tuti: %{fruit: fruit} = frooti}), do: [frooti, fruit]

  # They both return the same value.
  def test do
    val = val()
    one = lhs(val)
    two = rhs(val)
    tuti = val[:tuti]
    tuti = one = two
  end
end

_ = """
ExUnitProperties is a thing! As an alternative to ExPropCheck, you can use the StreamData library which comes with generators and the
ExUnitProperties extension for ExUnit.
"""

_ = """
p.270
When you’re initializing a server, don’t interact with anything that uses that server.
"""
