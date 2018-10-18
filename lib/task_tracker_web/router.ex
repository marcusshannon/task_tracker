defmodule TaskTrackerWeb.Router do
  use TaskTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TaskTrackerWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/login", PageController, :log_in
    post "/login", UserController, :log_in
    get "/logout", UserController, :log_out
    resources "/users", UserController, only: [:new, :create]
    # resources "/tasks", TaskController, only: [:index, :create, :new]

    pipe_through :authenticate
    resources "/tasks", TaskController, only: [:create, :new, :delete]
    post "/increment/:id", TaskController, :increment
    post "/decrement/:id", TaskController, :decrement
    post "/complete/:id", TaskController, :complete

    pipe_through :owner
    resources "/users", UserController, only: [:show]

  end

  scope "/", TaskTrackerWeb do
    pipe_through :task_owner

  end

  def authenticate(conn, _) do
    case Plug.Conn.get_session(conn, :current_user) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "You need to be logged in for that")
        |> Phoenix.Controller.redirect(to: "/")
        |> Plug.Conn.halt()

      user_id ->
        conn
        |> Plug.Conn.assign(:current_user, TaskTracker.Users.get_user!(user_id))
    end
  end

  def owner(conn, _) do
    if conn.assigns.current_user.id == String.to_integer(conn.params["id"]) do
      conn
    else
      conn
      |> Phoenix.Controller.render(TaskTrackerWeb.ErrorView, "403.html")
      |> Plug.Conn.halt()
    end
  end
end
