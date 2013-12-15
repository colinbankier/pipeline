defmodule Database do
  use Rethinkdb

  def setup do
    r.table_drop("task_results").run!
    r.table_create("task_results").run!
  end
end
