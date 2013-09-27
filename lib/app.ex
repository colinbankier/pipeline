defmodule Pipeline do

  import Weber

  def start(_type, _args) do
    {:ok, root} = :file.get_cwd()
    run_weber(:Pipeline, Route.get_route, root, Config.config)
  end

  def stop(_state) do
    :ok
  end
end
