defmodule Domain do
  defmodule Task do
    defstruct type: :task, id: nil, name: nil, command: nil
  end

  defmodule Pipeline do
    defstruct type: :pipeline, id: nil, name: nil, tasks: []

    def find([ head | [] ], pipeline) do
      if head == pipeline.name do
        pipeline
      else
        nil
      end
    end

    def find([ head | tail ], pipeline) do
      if head == pipeline.name do
        [ next | rest ] = tail
        task = Enum.find(pipeline.tasks, fn(task) ->
          task.name == next
        end)
        find(tail, task)
      else
        nil
      end
    end

  def from_json json do
    {:ok, data} = JSEX.decode json
    pipeline = convert data
    {:ok, pipeline}
  end

  def convert elem do
    cond do
      Dict.has_key? elem, "tasks" ->
        %Pipeline{name: elem["name"],
         tasks: Enum.map(elem["tasks"], &(convert(&1)))}
      Dict.has_key? elem, "command" ->
        %Task{name: elem["name"], command: elem["command"]}
    end
  end
  end
end
