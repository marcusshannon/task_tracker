defmodule TaskTrackerWeb.UserController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Users
  alias TaskTracker.Users.User

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> put_session(:current_user, user.id)
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user =
      Users.get_user!(id)
      |> Users.load_tasks()

    render(conn, "show.html", user: user, token: get_csrf_token())
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def log_in(conn, %{"name" => name}) do
    case Users.get_user_by_name(name) do
      nil ->
        conn
        |> put_flash(:error, "User not found")
        |> redirect(to: Routes.page_path(conn, :index))

      user ->
        conn
        |> put_session(:current_user, user.id)
        |> redirect(to: Routes.user_path(conn, :show, user))
    end
  end

  def log_out(conn, _) do
    conn
    |> clear_session
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
