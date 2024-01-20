defmodule GenstageDemo2023.TaskDBInterface do
  import Ecto.Query

  def take_tasks(limit) do
    {:ok, {count, events}} =
      GenstageDemo2023.Repo.transaction fn ->
        ids = GenstageDemo2023.Repo.all waiting(limit)
        {count, _} = GenstageDemo2023.Repo.update_all by_ids(ids), [set: [status: "running"]], [returning: [:id, :payload]]
        updates = GenstageDemo2023.Repo.all running(ids)
       # IO.puts("updates #{inspect(updates)}")
        {count, updates}
      end
#    IO.puts("ECTO#{inspect(events)}, ---- #{inspect(count)}")
    {count, events}
  end

  def insert_tasks(status, payload) do
    IO.puts("TASK #{inspect(payload)}")
    GenstageDemo2023.Repo.insert_all "tasks", [
      %{status: status, payload: payload}
    ]
  end

  def update_task_status(id, status) do
    GenstageDemo2023.Repo.update_all by_ids([id]), set: [status: status]
  end

  defp by_ids(ids) do
    from t in "tasks", where: t.id in ^ids
  end

  defp running(ids) do
    from t in "tasks",
      where: t.status == "running" and t.id in ^ids,
      select: [id: t.id, payload: t.payload]
  end

  defp waiting(limit) do
    from t in "tasks",
      where: t.status == "waiting",
      limit: ^limit,
      select: t.id,
      lock: "FOR UPDATE SKIP LOCKED"
  end
end

