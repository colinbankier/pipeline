import Pipeline.TestHelper

defmodule BuildNumberTest do
  use ExUnit.Case

  setup do
    BuildNumber.clear_all
    :ok
  end

  test "get sequential build number for pipeline" do
    assert BuildNumber.next!(["BuildNumber Pipeline"]) == 1
    assert BuildNumber.next!(["BuildNumber Pipeline"]) == 2
  end
end
