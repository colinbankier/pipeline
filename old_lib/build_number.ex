defmodule BuildNumber do

  @db_path "db/build_numbers.json"

  def next! key do
    json_key = Enum.join(key)
    json_key |>
    get_current |>
    increment |>
    store_next(json_key)
  end

  def get_current key do
    read_db |>
    get_key(key)
  end

  def read_db do
    File.read(@db_path) |>
    IO.inspect |>
    decode
  end

  def decode {:error, _} do
    HashDict.new
  end

  def decode {:ok, json} do
    JSEX.decode! json
  end

  def get_key map, key do
    IO.inspect map
    IO.inspect key
    Dict.get(map, key, 0)
  end

  def increment int do
    int + 1
  end

  def store_next int, key do
    IO.puts "store"
    new_dict = read_db |> Dict.put key, int
    {:ok, json} = JSEX.encode(new_dict)
    IO.puts json
    File.write! @db_path, json |>
    IO.inspect
    int
  end

  def clear_all do
    File.rm @db_path
  end
end
