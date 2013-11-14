defmodule Models do
  defrecord Pipeline, id: nil, name: nil, tasks: []
  defrecord Task, id: nil, name: nil, command: nil
end
