defmodule Day1 do
  def calibration_sum_part_1 do
    file_path = Path.join(__DIR__, "input.txt")

    case File.read(file_path) do
      {:ok, content} -> process_part_1(content)
      _ -> {:error, "could not read file"}
    end
  end

  def calibration_sum_part_2 do
    file_path = Path.join(__DIR__, "second_input.txt")

    case File.read(file_path) do
      {:ok, content} -> process_part_2(content)
      _ -> {:error, "could not read file"}
    end
  end

  def process_part_1(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&extract_calibration_value/1)
    |> Enum.sum()
  end

  def process_part_2(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> filter(l) end)
    |> Enum.map(&extract_calibration_value/1)
    |> Enum.sum()
  end

  def extract_calibration_value(line) do
    digits = Regex.scan(~r/\d/, line) |> List.flatten()

    case digits do
      [first | rest] ->
        last_digit = List.last(rest) || first
        String.to_integer(first <> last_digit)
    end
  end

  def filter(""), do: ""
  def filter(<<x, rest::binary>>) when x in ?1..?9, do: <<x>> <> filter(rest)
  def filter("one" <> rest), do: "1" <> filter("e" <> rest)
  def filter("two" <> rest), do: "2" <> filter("o" <> rest)
  def filter("three" <> rest), do: "3" <> filter("e" <> rest)
  def filter("four" <> rest), do: "4" <> filter(rest)
  def filter("five" <> rest), do: "5" <> filter("e" <> rest)
  def filter("six" <> rest), do: "6" <> filter(rest)
  def filter("seven" <> rest), do: "7" <> filter("n" <> rest)
  def filter("eight" <> rest), do: "8" <> filter("t" <> rest)
  def filter("nine" <> rest), do: "9" <> filter("e" <> rest)
  def filter(<<_, rest::binary>>), do: filter(rest)
end
