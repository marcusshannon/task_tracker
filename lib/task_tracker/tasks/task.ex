defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field(:description, :string)
    field(:title, :string)
    field(:completed, :boolean)
    field(:time, :integer)
    belongs_to(:user, TaskTracker.Users.User)

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:title])
  end
end
