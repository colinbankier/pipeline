defmodule Models do
  defmodule Pipeline do
    defstruct type: :pipeline, id: nil, name: nil, tasks: []
  end

  defmodule Task do
    defstruct type: :task, id: nil, name: nil, command: nil
  end
end
