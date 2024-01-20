defmodule GenstageDemo2023.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
   # consumers = for id <- (0..System.schedulers_online * 12) do
    consumers = for id <- (0..0) do
                  Supervisor.child_spec({GenstageDemo2023.Consumer, []}, id: id)
                end

    supervisors = [
                    GenstageDemo2023.Repo, 
        {GenstageDemo2023.Producer, []},
                  {Task.Supervisor, [name: GenstageDemo2023.TaskSupervisor]},
                  ]
    children = supervisors ++ consumers


    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GenstageDemo2023.Supervisor]
    Supervisor.start_link(children, opts)
  end

  
  def start_later(module, function, args) do
    payload = {module, function, args} |> :erlang.term_to_binary
    GenstageDemo2023.Repo.insert_all("tasks", [
                              %{status: "waiting", payload: payload}
                             ])
    notify_producer()
  end

  def notify_producer do
    send(GenstageDemo2023.Producer, :data_inserted)
  end

end
