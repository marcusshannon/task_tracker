defmodule TaskTracker.Repo.Migrations.CreateBlocks do
  use Ecto.Migration

  def change do
    create table(:blocks) do
      add(:start, :naive_datetime)
      add(:end, :naive_datetime)
      add(:task_id, references(:tasks, on_delete: :delete_all))

      timestamps()
    end

    create(index(:blocks, [:task_id]))
  end
end
