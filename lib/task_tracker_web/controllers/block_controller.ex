defmodule TaskTrackerWeb.BlockController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Blocks
  alias TaskTracker.Blocks.Block

  action_fallback TaskTrackerWeb.FallbackController

  def index(conn, _params) do
    blocks = Blocks.list_blocks()
    render(conn, "index.json", blocks: blocks)
  end

  def create(conn, block_params) do
    with {:ok, %Block{}} <- Blocks.create_block(block_params) do
      conn
      |> redirect(to: Routes.user_path(conn, :show, conn.assigns.current_user.id))
      # |> put_status(:created)
      # |> put_resp_header("location", Routes.block_path(conn, :show, block))
      # |> render("show.json", block: block)
    end
  end

  def show(conn, %{"id" => id}) do
    block = Blocks.get_block!(id)
    render(conn, "show.json", block: block)
  end

  def update(conn, %{"id" => id, "block" => block_params}) do
    block = Blocks.get_block!(id)

    with {:ok, %Block{} = block} <- Blocks.update_block(block, block_params) do
      render(conn, "show.json", block: block)
    end
  end

  def delete(conn, %{"id" => id}) do
    block = Blocks.get_block!(id)

    with {:ok, %Block{}} <- Blocks.delete_block(block) do
      send_resp(conn, :no_content, "")
    end
  end
end
