defmodule Csv2JsonTest do
  use ExUnit.Case, async: false

  setup do
    File.rm "./test/data/output.json"
    :ok
  end

  test "Convert CSV to JSON" do
    refute File.exists?("./test/data/output.json")
    Csv2Json.main(["./test/data/input1.csv", "--output", "./test/data/output.json"])
    assert File.exists?("./test/data/output.json")

    assert File.read!("./test/data/output.json") == """
      {"user_agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246","time":"1488921440833273489","remote_addr":"127.0.0.1","name":"requests"}
      {"user_agent":"","time":"1488921441686269512","remote_addr":"10.0.0.2","name":"requests"}
      {"user_agent":"user agent \\"string\\"","time":"1488921441686269515","remote_addr":"192.168.0.1","name":"requests"}
      {"user_agent":"","time":"1488921441686269590","remote_addr":"","name":"requests"}
      """
  end
end
