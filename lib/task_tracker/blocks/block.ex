defmodule TaskTracker.Blocks.Block do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blocks" do
    field(:end, :naive_datetime)
    field(:start, :naive_datetime)
    belongs_to(:task, TaskTracker.Tasks.Task)

    timestamps()
  end

  @doc false
  def changeset(block, attrs) do
    block
    |> cast(attrs, [:start, :end, :task_id])
    |> validate_required([:task_id])
  end
end
