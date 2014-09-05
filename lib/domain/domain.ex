defmodule Domain do
  defmodule Task do
    defstruct type: :task, id: nil, name: nil, command: nil
  end

  defmodule Pipeline do
    defstruct type: :pipeline, id: nil, name: nil, tasks: []

  def find_sub_task(path, %Task{}) do
    path
  end

  def find_sub_task(path, pipeline = %Pipeline{}) do
    task = pipeline.tasks |> List.first
    subtask_path = List.insert_at(path, -1, task.name)

    find_sub_task(subtask_path, task)
  end

  def find_next_task [ head ], pipeline do
    nil
  end

  def find_next_task path, pipeline do
    [ head | tail ] = path |> Enum.reverse
    parent_path = Enum.reverse(tail)
    parent = find(parent_path, pipeline)
    index = Enum.find_index parent.tasks, fn task ->
      task.name == head
    end
    if index + 1 >= Enum.count(parent.tasks) do
      find_next_task(parent_path, pipeline)
    else
      task = Enum.at(parent.tasks, index + 1)
      reversed_path = [task.name | tail]
      reversed_path |> Enum.reverse
    end
  end

  def find_task(path, pipeline = %Pipeline{}) do
    task = pipeline.tasks |> List.first
    find_task([pipeline.name | path], task)
  end

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
