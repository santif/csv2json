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
          |> Stream.map(fn(obj) ->
              IO.puts(output_file, Poison.encode!(obj))
            end)
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
end
