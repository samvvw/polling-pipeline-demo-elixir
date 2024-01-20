defmodule GenstageDemo2023 do
  @moduledoc """
  Documentation for `GenstageDemo2023`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> GenstageDemo2023.hello()
      :world

  """
  def hello do
    :world
  end
  defdelegate enqueue(module, function, args), to: GenstageDemo2023.Producer
end
