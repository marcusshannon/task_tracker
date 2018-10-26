defmodule TaskTracker.BlocksTest do
  use TaskTracker.DataCase

  alias TaskTracker.Blocks

  describe "blocks" do
    alias TaskTracker.Blocks.Block

    @valid_attrs %{end: ~D[2010-04-17], start: ~D[2010-04-17]}
    @update_attrs %{end: ~D[2011-05-18], start: ~D[2011-05-18]}
    @invalid_attrs %{end: nil, start: nil}

    def block_fixture(attrs \\ %{}) do
      {:ok, block} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blocks.create_block()

      block
    end

    test "list_blocks/0 returns all blocks" do
      block = block_fixture()
      assert Blocks.list_blocks() == [block]
    end

    test "get_block!/1 returns the block with given id" do
      block = block_fixture()
      assert Blocks.get_block!(block.id) == block
    end

    test "create_block/1 with valid data creates a block" do
      assert {:ok, %Block{} = block} = Blocks.create_block(@valid_attrs)
      assert block.end == ~D[2010-04-17]
      assert block.start == ~D[2010-04-17]
    end

    test "create_block/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blocks.create_block(@invalid_attrs)
    end

    test "update_block/2 with valid data updates the block" do
      block = block_fixture()
      assert {:ok, %Block{} = block} = Blocks.update_block(block, @update_attrs)

      
      assert block.end == ~D[2011-05-18]
      assert block.start == ~D[2011-05-18]
    end

    test "update_block/2 with invalid data returns error changeset" do
      block = block_fixture()
      assert {:error, %Ecto.Changeset{}} = Blocks.update_block(block, @invalid_attrs)
      assert block == Blocks.get_block!(block.id)
    end

    test "delete_block/1 deletes the block" do
      block = block_fixture()
      assert {:ok, %Block{}} = Blocks.delete_block(block)
      assert_raise Ecto.NoResultsError, fn -> Blocks.get_block!(block.id) end
    end

    test "change_block/1 returns a block changeset" do
      block = block_fixture()
      assert %Ecto.Changeset{} = Blocks.change_block(block)
    end
  end
end
