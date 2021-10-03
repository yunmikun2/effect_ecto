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
             |> EffectEcto.all()
             |> Effect.execute()
  end

  test "apply_changes" do
    assert {:ok, %Record{x: 1}} =
             %Record{}
             |> Ecto.Changeset.change(x: 1)
             |> EffectEcto.apply_changes()
             |> Effect.execute()
  end

  test "delete" do
    record = Repo.insert!(%Record{x: 1})

    assert {:ok, %Record{x: 1}} =
             record
             |> EffectEcto.delete()
             |> Effect.execute()

    assert [] = Repo.all(Record)
  end

  test "get" do
    record = Repo.insert!(%Record{x: 1})

    assert {:ok, %Record{x: 1}} =
             Record
             |> EffectEcto.get(record.id)
             |> Effect.execute()
  end

  test "get_by" do
    Repo.insert!(%Record{x: 1})

    assert {:ok, %Record{x: 1}} =
             Record
             |> EffectEcto.get_by(%{x: 1})
             |> Effect.execute()
  end

  test "insert" do
    assert {:ok, %Record{id: id}} =
             %Record{x: 1}
             |> EffectEcto.insert()
             |> Effect.execute()

    assert [%Record{id: ^id}] = Repo.all(Record)
  end

  test "insert_all" do
    assert {:ok, {1, _}} =
             Record
             |> EffectEcto.insert_all([%{x: 1}])
             |> Effect.execute()

    assert [%Record{x: 1}] = Repo.all(Record)
  end

  test "insert_or_update" do
    assert {:ok, %Record{x: 1}} =
             %Record{x: 1}
             |> Ecto.Changeset.change()
             |> EffectEcto.insert_or_update()
             |> Effect.execute()

    assert [%Record{x: 1}] = Repo.all(Record)
  end

  test "multi success" do
    multi = Ecto.Multi.insert(Ecto.Multi.new(), :record, %Record{x: 1})

    assert {:ok, %{record: %Record{x: 1}}} =
             multi
             |> EffectEcto.multi()
             |> Effect.execute()
  end

  test "multi fail" do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:record, %Record{x: 1})
      |> Ecto.Multi.run(:fail, fn _, _ -> {:error, "oops"} end)

    assert {:error,
            %{
              failed_operation: :fail,
              failed_value: "oops",
              changes_so_far: %{record: %Record{x: 1}}
            }} =
             multi
             |> EffectEcto.multi()
             |> Effect.execute()

    assert [] = Repo.all(Record)
  end

  test "one" do
    Repo.insert!(%Record{x: 1})

    assert {:ok, %Record{x: 1}} =
             Record
             |> EffectEcto.one()
             |> Effect.execute()
  end

  test "preload" do
    record = Repo.insert!(%Record{x: 1})
    Repo.insert!(%Record.Sub{y: 2, record_id: record.id})

    assert {:ok, %Record{subs: [%Record.Sub{y: 2}]}} =
             record
             |> EffectEcto.preload([:subs])
             |> Effect.execute()
  end

  test "transaction success" do
    assert {:ok, %Record{x: 1}} =
             %Record{x: 1}
             |> EffectEcto.insert()
             |> EffectEcto.transaction()
             |> Effect.execute()

    assert [%Record{x: 1}] = Repo.all(Record)
  end

  test "transaction fail" do
    assert {:error, "oops"} =
             %Record{x: 1}
             |> EffectEcto.insert()
             |> Effect.bind(fn _ -> Effect.fail("oops") end)
             |> EffectEcto.transaction()
             |> Effect.execute()

    assert [] = Repo.all(Record)
  end

  test "transaction, being interpreted doesn't try to execute inner effect" do
    assert {:ok, :ok} =
             Effect.return(:ok)
             |> Effect.map(fn :ok -> :ok end)
             |> EffectEcto.transaction()
             |> Effect.interpret(fn _ -> :not_gonna_happen end)
  end

  test "update" do
    record = Repo.insert!(%Record{x: 1})

    assert {:ok, %Record{x: 2}} =
             record
             |> Ecto.Changeset.change(x: 2)
             |> EffectEcto.update()
             |> Effect.execute()
  end

  test "update_all" do
    record = Repo.insert!(%Record{x: 1})

    assert {:ok, {1, _}} =
             Record
             |> EffectEcto.update_all(set: [x: 2])
             |> Effect.execute()

    assert %Record{x: 2} = Repo.get(Record, record.id)
  end
end
