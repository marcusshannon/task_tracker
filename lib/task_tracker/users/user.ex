defmodule TaskTracker.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    has_many(:tasks, TaskTracker.Tasks.Task)
    has_many(:users, TaskTracker.Users.User, foreign_key: :manager_id)
    belongs_to(:manager, TaskTracker.Users.User)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :manager_id])
    |> validate_required([:name])
    |> foreign_key_constraint(:manager_id)
    |> unique_constraint(:name)
  end
end
