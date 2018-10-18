defmodule TaskTrackerWeb.TaskController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Tasks
  alias TaskTracker.Tasks.Task

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, conn.assigns.current_user.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    case Tasks.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)

    if task_owner(task, conn.assigns.current_user.id) do
      {:ok, _task} = Tasks.delete_task(task)

      conn
      |> put_flash(:info, "Task deleted successfully.")
      |> redirect(to: Routes.user_path(conn, :show, conn.assigns.current_user.id))
    else
      conn
      |> Phoenix.Controller.render(TaskTrackerWeb.ErrorView, "403.html")
    end
  end

  def increment(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)

    if task_owner(task, conn.assigns.current_user.id) do
      task = Tasks.increment(task)
      redirect(conn, to: Routes.user_path(conn, :show, conn.assigns.current_user.id))
    else
      conn
      |> Phoenix.Controller.render(TaskTrackerWeb.ErrorView, "403.html")
    end
  end

  def decrement(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)

    if task_owner(task, conn.assigns.current_user.id) do
      task = Tasks.decrement(task)
      redirect(conn, to: Routes.user_path(conn, :show, conn.assigns.current_user.id))
    else
      conn
      |> Phoenix.Controller.render(TaskTrackerWeb.ErrorView, "403.html")
    end
  end

  def complete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)

    if task_owner(task, conn.assigns.current_user.id) do
      task = Tasks.complete(task)
      redirect(conn, to: Routes.user_path(conn, :show, conn.assigns.current_user.id))
    else
      conn
      |> Phoenix.Controller.render(TaskTrackerWeb.ErrorView, "403.html")
    end
  end

  def task_owner(task, user_id) do
    task.user_id == user_id
  end
end
