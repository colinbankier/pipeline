defmodule Models do
  defrecord Pipeline, name: nil, tasks: []
  defrecord Task, name: nil, command: nil
end
