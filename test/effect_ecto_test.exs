defmodule EffectEctoTest do
  use ExUnit.Case

  alias EffectEcto.{Record, Repo}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "all" do
    Repo.insert!(%Record{x: 1})

    assert {:ok, [%Record{x: 1}]} =
             Record
             |> EffectEcto.All.new(Repo)
             |> Effect.execute()
  end

  test "delete" do
    record = Repo.insert!(%Record{x: 1})

    assert {:ok, %Record{x: 1}} =
             record
             |> EffectEcto.Delete.new(Repo)
             |> Effect.execute()

    assert [] = Repo.all(Record)
  end

  test "get" do
    record = Repo.insert!(%Record{x: 1})

    assert {:ok, %Record{x: 1}} =
             Record
             |> EffectEcto.Get.new(record.id, Repo)
             |> Effect.execute()
  end

  test "get_by" do
    Repo.insert!(%Record{x: 1})

    assert {:ok, %Record{x: 1}} =
             Record
             |> EffectEcto.GetBy.new(%{x: 1}, Repo)
             |> Effect.execute()
  end

  test "insert" do
    assert {:ok, %Record{id: id}} =
             %Record{x: 1}
             |> EffectEcto.Insert.new(Repo)
             |> Effect.execute()

    assert [%Record{id: ^id}] = Repo.all(Record)
  end

  test "insert_all" do
    assert {:ok, {1, _}} =
             Record
             |> EffectEcto.InsertAll.new([%{x: 1}], Repo)
             |> Effect.execute()

    assert [%Record{x: 1}] = Repo.all(Record)
  end

  test "insert_or_update" do
    assert {:ok, %Record{x: 1}} =
             %Record{x: 1}
             |> Ecto.Changeset.change()
             |> EffectEcto.InsertOrUpdate.new(Repo)
             |> Effect.execute()

    assert [%Record{x: 1}] = Repo.all(Record)
  end

  test "one" do
    Repo.insert!(%Record{x: 1})

    assert {:ok, %Record{x: 1}} =
             Record
             |> EffectEcto.One.new(Repo)
             |> Effect.execute()
  end

  test "preload" do
    record = Repo.insert!(%Record{x: 1})
    Repo.insert!(%Record.Sub{y: 2, record_id: record.id})

    assert {:ok, %Record{subs: [%Record.Sub{y: 2}]}} =
             record
             |> EffectEcto.Preload.new([:subs], Repo)
             |> Effect.execute()
  end

  test "transaction" do
    assert {:error, "oops"} =
             %Record{x: 1}
             |> EffectEcto.Insert.new(Repo)
             |> Effect.Monad.bind(fn _ -> Effect.Fail.new("oops") end)
             |> EffectEcto.Transaction.new(Repo)
             |> Effect.execute()

    assert [] = Repo.all(Record)
  end

  test "update" do
    record = Repo.insert!(%Record{x: 1})

    assert {:ok, %Record{x: 2}} =
             record
             |> Ecto.Changeset.change(x: 2)
             |> EffectEcto.Update.new(Repo)
             |> Effect.execute()
  end

  test "update_all" do
    record = Repo.insert!(%Record{x: 1})

    assert {:ok, {1, _}} =
             Record
             |> EffectEcto.UpdateAll.new([set: [x: 2]], Repo)
             |> Effect.execute()

    assert %Record{x: 2} = Repo.get(Record, record.id)
  end
end
