defmodule Pipeline do

  defrecord Task, cmd: nil

  def run(pipe) do
    Enum.map pipe, fn task ->
      [
        cmd: task.cmd,
        output: System.cmd(task.cmd)
      ]
    end
  end

end
