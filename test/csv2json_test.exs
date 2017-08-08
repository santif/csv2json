defmodule Csv2JsonTest do
  use ExUnit.Case, async: false

  @output_file "./test/data/output.json.txt"

  setup do
    File.rm @output_file
    :ok
  end

  test "Convert CSV to JSON" do
    refute File.exists? @output_file
    Csv2Json.main(["./test/data/input1.csv", "--output", @output_file])
    assert File.exists? @output_file

    json_txt = File.read! @output_file
    assert json_txt == """
      {"user_agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246","time":"2017-04-07T12:34:56.123Z","remote_addr":"127.0.0.1","name":"requests"}
      {"time":"2017-04-07T12:34:56.234Z","remote_addr":"10.0.0.2","name":"requests"}
      {"user_agent":"user agent \\"string\\"","time":"2017-04-07T12:34:56.345Z","remote_addr":"192.168.0.1","name":"requests"}
      {"time":"2017-04-07T12:34:56.456Z","name":"requests"}
      """

    [line1, line2, line3, line4, ""] = String.split(json_txt, "\n")

    obj = Poison.decode!(line1)
    assert obj["name"] == "requests"
    assert obj["time"] == "2017-04-07T12:34:56.123Z"
    assert obj["remote_addr"] == "127.0.0.1"
    assert obj["user_agent"] == "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246"

    obj = Poison.decode!(line2)
    assert obj["name"] == "requests"
    assert obj["time"] == "2017-04-07T12:34:56.234Z"
    assert obj["remote_addr"] == "10.0.0.2"
    assert obj["user_agent"] == nil

    obj = Poison.decode!(line3)
    assert obj["name"] == "requests"
    assert obj["time"] == "2017-04-07T12:34:56.345Z"
    assert obj["remote_addr"] == "192.168.0.1"
    assert obj["user_agent"] == "user agent \"string\""

    obj = Poison.decode!(line4)
    assert obj["name"] == "requests"
    assert obj["time"] == "2017-04-07T12:34:56.456Z"
    assert obj["remote_addr"] == nil
    assert obj["user_agent"] == nil
  end
end
