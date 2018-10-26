defmodule TaskTrackerWeb.BlockView do
  use TaskTrackerWeb, :view
  alias TaskTrackerWeb.BlockView

  def render("index.json", %{blocks: blocks}) do
    %{data: render_many(blocks, BlockView, "block.json")}
  end

  def render("show.json", %{block: block}) do
    %{data: render_one(block, BlockView, "block.json")}
  end

  def render("block.json", %{block: block}) do
    %{id: block.id,
      start: block.start,
      end: block.end}
  end
end
