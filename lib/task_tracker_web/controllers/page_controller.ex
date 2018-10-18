defmodule TaskTrackerWeb.PageController do
  use TaskTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def log_in(conn, _params) do
    render(conn, "log_in.html")
  end
end
