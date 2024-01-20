defmodule GenstageDemo2023.Task do
  def enqueue(status, payload) do
    GenstageDemo2023.TaskDBInterface.insert_tasks(status, payload)
  end

  def take(limit) do
    GenstageDemo2023.TaskDBInterface.take_tasks(limit)
  end
end

