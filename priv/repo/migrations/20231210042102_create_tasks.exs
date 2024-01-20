defmodule GenstageDemo2023.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :payload, :binary
      add :status, :string
    end
  end
end
