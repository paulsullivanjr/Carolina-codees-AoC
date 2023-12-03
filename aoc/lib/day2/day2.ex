defmodule Day2 do
  @red_cubes 12
  @green_cubes 13
  @blue_cubes 14

  def cube_sum_part_1 do
    file_path = Path.join(__DIR__, "input.txt")

    case File.read(file_path) do
      {:ok, content} -> process(content)
      _ -> {:error, "could not read file"}
    end
  end

  def cube_sum_part_2 do
    file_path = Path.join(__DIR__, "second_input.txt")

    case File.read(file_path) do
      {:ok, content} -> process2(content)
      _ -> {:error, "could not read file"}
    end
  end

  def process2(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&extract_cube_value_2/1)
    |> Enum.sum()
  end

  def process(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&extract_cube_value/1)
    |> List.flatten()
    |> Enum.sum()
  end

  def extract_cube_value_2(line) do
    [game_id | games] = String.split(line, ":")
    id = extract_game_id(game_id)

    Enum.map(games, fn game ->
      String.split(game, ";")
      |> Enum.map(fn g ->
        String.split(g, ",")
        |> Enum.map(fn entry ->
          [count | [color]] = String.trim(entry) |> String.split(" ")

          [{String.trim(color) |> String.to_atom(), String.trim(count) |> String.to_integer()}]
          |> Enum.into(%{})
        end)
      end)
      |> List.flatten()
      |> Enum.group_by(&(Map.keys(&1) |> List.first()), & &1)
      |> Enum.into(%{})
      |> calculate_power(id)
    end)
    |> List.flatten()
    |> Enum.map(fn {_id, power} -> power end)
    |> Enum.sum()
  end

  def calculate_power(maps, id) do
    %{green: green_list} = maps
    %{red: red_list} = maps
    %{blue: blue_list} = maps
    {:ok, min_red} = red_list |> Enum.map(&Map.fetch(&1, :red)) |> Enum.max()
    {:ok, min_green} = green_list |> Enum.map(&Map.fetch(&1, :green)) |> Enum.max()
    {:ok, min_blue} = blue_list |> Enum.map(&Map.fetch(&1, :blue)) |> Enum.max()

    {id, min_red * min_green * min_blue}
  end

  def extract_cube_value(line) do
    [game_id | games] = String.split(line, ":")
    id = extract_game_id(game_id)

    games
    |> Enum.map(fn game ->
      process_game(game)
      |> Enum.all?()
      |> add_game_id(id)
    end)
  end

  defp add_game_id(true, game_id), do: [game_id]
  defp add_game_id(false, _), do: [0]

  def process_game(game) do
    game
    |> String.split(";")
    |> Enum.map(&check_counts/1)
  end

  defp check_counts(game_counts) do
    game_counts
    |> String.split(",")
    |> Enum.map(&check_count/1)
    |> Enum.all?()
  end

  defp check_count(color_count) do
    [count_str, color] = String.split(color_count)
    count = String.to_integer(count_str)

    case color do
      "red" when count > @red_cubes -> false
      "green" when count > @green_cubes -> false
      "blue" when count > @blue_cubes -> false
      _ -> true
    end
  end

  def extract_game_id(value) do
    [h | t] = String.split(value, ":")
    String.split(h, " ") |> List.last() |> String.to_integer()
  end
end
