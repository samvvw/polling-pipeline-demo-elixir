defmodule GenstageDemo2023.Producer do
  use GenStage

  @name __MODULE__

  def start_link(_) do
    GenStage.start_link(__MODULE__, 0, name: @name)
  end

  def init(counter) do
    send(self(), :enqueued)
    {:producer, counter}
  end

  def enqueue(module, function, args) do
    payload = {module, function, args} |> construct_payload
    GenstageDemo2023.Task.enqueue("waiting", payload)
    Process.send(@name, :enqueued, [])
    :ok
  end

  def handle_cast(:enqueued, state) do
    IO.inspect("CAST")
    serve_jobs(state)
  end

  def handle_demand(demand, state) do
    IO.inspect("Demand #{demand} + State #{state}")
    serve_jobs(demand + state)
  end

  def handle_info(:enqueued, state) do
    {count, events} = GenstageDemo2023.Task.take(state)
    IO.inspect("handle_info #{count}, events: #{inspect(events)}, diff: #{state - count}")
    
      Process.send_after(@name, :enqueued, 6000)
    {:noreply, events, state - count}
  end

  def serve_jobs limit do
    {count, events} = GenstageDemo2023.Task.take(limit)
  #    Process.send_after(@name, :enqueued, 6000)
    IO.inspect("serve_jobs #{limit - count}, events: #{inspect(events)} limit #{limit}")
    {:noreply, events, limit - count}
  end

  defp construct_payload({module, function, args}) do
    {module, function, args} |> :erlang.term_to_binary
  end
end

