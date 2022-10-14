defmodule PubSubTest.Repo.Migrations.CreateTriggers do
  use Ecto.Migration

  def up do
    execute("""
      CREATE OR REPLACE FUNCTION notify_user_changed()
      RETURNS trigger as $$
      BEGIN
          PERFORM pg_notify(
            'user_changed',
            json_build_object(
              'operation', TG_OP,
              'before', row_to_json(OLD),
              'after', row_to_json(NEW)
            )::text
          );

        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    """)

    execute("DROP TRIGGER IF EXISTS user_changed on users")

    execute("""
      CREATE TRIGGER user_changed
      AFTER INSERT OR UPDATE OR DELETE
      ON users
      FOR EACH ROW
      EXECUTE PROCEDURE notify_user_changed()
    """)
  end

  def down do
    execute("DROP TRIGGER IF EXISTS user_changed on users")
    execute("DROP FUNCTION IF EXISTS notify_user_changed")
  end
end
