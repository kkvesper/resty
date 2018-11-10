defmodule Resty.Serializer.Json do
  @moduledoc false
  def decode(json, allowed_fields) do
    json
    |> to_map()
    |> remove_root()
    |> filter_fields(allowed_fields)
  end

  defp to_map(json) do
    case Jason.decode(json) do
      {:error, error} -> raise error
      {:ok, result} -> result
    end
  end

  defp remove_root(map) do
    do_remove_root(map, Map.keys(map))
  end

  defp do_remove_root(map, [key | []]) do
    case Map.get(map, key) do
      data when is_map(data) -> data
      _ -> map
    end
  end

  defp do_remove_root(map, _), do: map

  defp filter_fields(data, allowed_fields) do
    do_filter_fields(allowed_fields, data, %{})
  end

  defp do_filter_fields([], _, filtered_fields), do: filtered_fields

  defp do_filter_fields([field | next_fields], data, filtered_fields) do
    field_key = field |> to_string()

    updated_filtered_fields =
      case Map.get(data, field_key, false) do
        false ->
          filtered_fields

        value ->
          Map.put(filtered_fields, field, value)
      end

    do_filter_fields(next_fields, data, updated_filtered_fields)
  end

  # Encoding
  def encode(map, allowed_fields, root \\ false) do
    map = Map.take(map, allowed_fields)

    to_encode = case root do
      false -> map
      root -> Map.put(%{}, root, map)
    end

    to_encode |> Jason.encode!([])
  end
end