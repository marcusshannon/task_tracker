defmodule TaskTrackerWeb.BlockControllerTest do
  use TaskTrackerWeb.ConnCase

  alias TaskTracker.Blocks
  alias TaskTracker.Blocks.Block

  @create_attrs %{
    end: ~D[2010-04-17],
    start: ~D[2010-04-17]
  }
  @update_attrs %{
    end: ~D[2011-05-18],
    start: ~D[2011-05-18]
  }
  @invalid_attrs %{end: nil, start: nil}

  def fixture(:block) do
    {:ok, block} = Blocks.create_block(@create_attrs)
    block
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all blocks", %{conn: conn} do
      conn = get(conn, Routes.block_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create block" do
    test "renders block when data is valid", %{conn: conn} do
      conn = post(conn, Routes.block_path(conn, :create), block: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.block_path(conn, :show, id))

      assert %{
               "id" => id,
               "end" => "2010-04-17",
               "start" => "2010-04-17"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.block_path(conn, :create), block: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update block" do
    setup [:create_block]

    test "renders block when data is valid", %{conn: conn, block: %Block{id: id} = block} do
      conn = put(conn, Routes.block_path(conn, :update, block), block: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.block_path(conn, :show, id))

      assert %{
               "id" => id,
               "end" => "2011-05-18",
               "start" => "2011-05-18"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, block: block} do
      conn = put(conn, Routes.block_path(conn, :update, block), block: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete block" do
    setup [:create_block]

    test "deletes chosen block", %{conn: conn, block: block} do
      conn = delete(conn, Routes.block_path(conn, :delete, block))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.block_path(conn, :show, block))
      end
    end
  end

  defp create_block(_) do
    block = fixture(:block)
    {:ok, block: block}
  end
end
