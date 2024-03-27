defmodule GenReport.Parser do
  def parse_file(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(fn line -> parse_line(line) end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> format()
  end

  defp format(parsed_line) do
    parsed_line
    |> List.update_at(0, &String.downcase/1)
    |> convert_to_integer([1, 2, 3, 4])
    |> convert_month_number_to_name()
  end

  defp convert_to_integer(parsed_line, indexes),
    do: convert_to_integer(parsed_line, indexes, 0, [])

  defp convert_to_integer([], _indexes, _index, acc), do: Enum.reverse(acc)

  defp convert_to_integer([head | tail], indexes, index, acc) do
    new_element =
      if index in indexes do
        String.to_integer(head)
      else
        head
      end

    convert_to_integer(tail, indexes, index + 1, [new_element | acc])
  end

  defp convert_month_number_to_name(parsed_line) do
    month_names = [
      "janeiro",
      "fevereiro",
      "março",
      "abril",
      "maio",
      "junho",
      "julho",
      "agosto",
      "setembro",
      "outubro",
      "novembro",
      "dezembro"
    ]

    List.update_at(parsed_line, 3, fn month_number ->
      Enum.at(month_names, month_number - 1)
    end)
  end
end
