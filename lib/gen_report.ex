defmodule GenReport do
  alias GenReport.Parser

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> process_file()
    |> reformat_data()
  end

  defp report_acc() do
    %{all_hours: 0, hours_per_month: %{}, hours_per_year: %{}}
  end

  defp process_file(parsed_lines) do
    Enum.reduce(parsed_lines, %{}, &process_line/2)
  end

  defp process_line([name, hours, _day, month, year], acc) do
    person_entry = Map.get(acc, name, report_acc())

    updated_all_hours = person_entry.all_hours + hours

    updated_hours_per_month =
      Map.update(
        person_entry.hours_per_month,
        month,
        hours,
        fn existing_hours -> existing_hours + hours end
      )

    updated_hours_per_year =
      Map.update(
        person_entry.hours_per_year,
        year,
        hours,
        fn existing_hours -> existing_hours + hours end
      )

    updated_person_entry = %{
      person_entry
      | all_hours: updated_all_hours,
        hours_per_month: updated_hours_per_month,
        hours_per_year: updated_hours_per_year
    }

    Map.put(acc, name, updated_person_entry)
  end

  def reformat_data(data) do
    Enum.reduce(data, initial_state(), fn {name, person_data}, acc ->
      update_state(acc, name, person_data)
    end)
  end

  defp initial_state do
    %{"all_hours" => %{}, "hours_per_month" => %{}, "hours_per_year" => %{}}
  end

  defp update_state(acc, name, %{
         all_hours: all_hrs,
         hours_per_month: hrs_month,
         hours_per_year: hrs_year
       }) do
    updated_all_hours = Map.put(acc["all_hours"], name, all_hrs)
    updated_hrs_per_month = Map.put(acc["hours_per_month"], name, hrs_month)
    updated_hrs_per_year = Map.put(acc["hours_per_year"], name, hrs_year)

    %{
      acc
      | "all_hours" => updated_all_hours,
        "hours_per_month" => updated_hrs_per_month,
        "hours_per_year" => updated_hrs_per_year
    }
  end
end
