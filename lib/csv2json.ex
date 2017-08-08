defmodule Csv2Json do
  @moduledoc false

  def main(args \\ []) do
    case OptionParser.parse!(args, strict: [output: :string]) do
      {[output: output_path], [input_path]} ->
        output_file = File.open! output_path, [:write]
        try do
          input_path
          |> File.stream!()
          |> CSV.decode!(headers: true)
          |> Stream.map(&encode_line/1)
          |> Stream.each(&IO.puts(output_file, &1))
          |> Stream.run()
        after
          File.close(output_file)
        end

      _ ->
        IO.write """
        csv2json - Converts CSV file to JSON (one JSON object per line)

        Usage: csv2json INPUT_FILE --output OUTPUT_FILE
        """
    end
  end

  @doc """
  Converts fields from a CSV line to JSON
  """
  def encode_line(obj) do
    obj
    |> Enum.filter(fn {_key, value} -> value != "" end)
    |> Enum.into(%{})
    |> Poison.encode!()
  end
end
