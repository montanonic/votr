defmodule Normalizer do
  alias Votr.Voting.{Room, User, VoteOption}

  def foo do
    StreamData.integer()
    |> Enum.take(10)
  end

  def mock_data do
    %Room{
      id: 0,
      users: [%User{room_id: 0, id: 0, name: "John"}, %User{room_id: 0, id: 1, name: "Marge"}],
      vote_options: [
        %VoteOption{room_id: 0, id: 0, name: "Soda"},
        %VoteOption{room_id: 0, id: 1, name: "James"}
      ]
    }
  end

  # Let's be real. This code is messy and needs a refactor. BUT, it work.
  def normalize(data, normalized \\ %{})

  def normalize(data, normalized) when is_struct(data) do
    meta = data.__meta__
    assocs = Normalizer.Ecto.associations(data)
    data_without_assocs = struct!(data.__struct__, Map.drop(data, assocs) |> Map.to_list())

    if id = Normalizer.Ecto.id(data) do
      updated_normalized_data =
        Map.update(
          normalized,
          String.to_atom(meta.source),
          %{id => data_without_assocs},
          &Map.put(&1, id, data_without_assocs)
        )

      for assoc <- assocs, reduce: updated_normalized_data do
        acc ->
          case Map.get(data, assoc) do
            %Ecto.Association.NotLoaded{} ->
              acc

            assoc_data ->
              Map.merge(acc, normalize(assoc_data, acc))
          end
      end
    else
      throw("Data is missing a primary key")
    end
  end

  def normalize(data, normalized) do
    for datum <- data, reduce: normalized do
      acc ->
        Map.merge(acc, normalize(datum, acc))
    end
  end

  defmodule Ecto do
    @doc """
    Takes either a schema instance or schema module, and returns both ecto
    associations and embeds for that schema.
    """
    def associations(%{__meta__: %{schema: schema}}), do: associations(schema)

    def associations(schema) do
      schema.__schema__(:associations) ++ schema.__schema__(:embeds)
    end

    @doc """
    Expects an instance of an ecto schema type. Returns the struct's id, or nil
    if missing.

    Supports multiple primary keys as well by returning a compound key (as a
    list of the primary-key values).
    """
    def id(%{__meta__: %{schema: schema}} = struct) do
      case schema.__schema__(:primary_key) do
        [] -> nil
        [id] -> Map.get(struct, id)
        list -> Enum.map(list, fn id -> Map.get(struct, id) end)
      end
    end
  end
end
