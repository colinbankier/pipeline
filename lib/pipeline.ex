defmodule Pipeline do

  defrecord Task, cmd: nil

  def run(pipe) do
    pipe 
    |> List.flatten
    |> Enum.map fn task ->
      [
        cmd: task.cmd,
        output: System.cmd(task.cmd),
        status: :success
      ]
    end
  end

end
