defmodule Repo.Migrations.CreateSubs do
  use Ecto.Migration

  def change do
    create table(:subs) do
      add(:record_id, references(:records), null: false)
      add(:y, :integer)
    end
  end
end
