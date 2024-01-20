defmodule GenstageDemo2023.Consumer do
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [{GenstageDemo2023.Producer, max_demand: 5}]}
  end

  def handle_events(events, _from, state) do
    IO.inspect("handle_events jobs #{inspect(events)}")
    for event <- events do
      [id: id, payload: payload] = event
      {module, function, args} = (payload |> deconstruct_payload())
   #   IO.inspect("#{inspect(module)}, #{inspect(function)}, #{inspect(args)}}}_>")
      task = start_task(module, function, args)
      yield_to_and_update_task(task, id)
    end
    {:noreply, [], state}
  end

  defp start_task(mod, func, args) do
    Task.Supervisor.async_nolink(GenstageDemo2023.TaskSupervisor, mod  , func, args)
  end

  defp yield_to_status({:ok, _}, _) do
    "success"
  end

  defp yield_to_status({:exit, _}, _) do
    "error"
  end

  defp yield_to_status(nil, task) do
    Task.shutdown(task)
    "timeout"
  end

  defp update(status, id) do
    GenstageDemo2023.TaskDBInterface.update_task_status(id, status)
  end

  defp yield_to_and_update_task(task, id) do
    task
    |> Task.yield(10_000)
    |> yield_to_status(task)
    |> update(id)
  end

  defp deconstruct_payload payload do
    payload |> :erlang.binary_to_term
  end
end

