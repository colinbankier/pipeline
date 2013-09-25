defmodule Pipeline do

  defrecord Task, cmd: nil

  def run(pipe) do
    pipe 
    |> List.flatten
    |> Enum.map fn task ->
      run_process(task.cmd)
    end
  end

  def run_process(command) do
    :exec.run(String.to_char_list!(command), [:stdout, :sync])
    |> build_run_result
  end

  def build_run_result({return_code, output}) do
    [
        output: single_string(Keyword.get(output, :stdout)),
        status: return_code
    ]
  end

  def single_string(nil) do
    ""
  end

  def single_string(output_list) do
    Enum.reduce(output_list, "", &(&2 <> &1))
  end
end
