defmodule Pipeline.Main do

  def action("GET", []) do
    {:render, [project: "pipeline"], []}
  end
        
end
