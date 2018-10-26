defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add(:title, :string, null: false)
      add(:description, :string)
      add(:completed, :boolean, default: false, null: false)
      add(:time, :integer, default: 0, null: false)
      add(:user_id, references(:users, on_delete: :nothing), null: false)

      timestamps()
    end

    create(index(:tasks, [:user_id]))
  end
end
