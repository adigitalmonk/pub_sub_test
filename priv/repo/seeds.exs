# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PubSubTest.Repo.insert!(%PubSubTest.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

%{
  name: "Bard",
  email: "bard@localhost",
  home_id: 1
}
|> PubSubTest.User.changeset()
|> PubSubTest.Repo.insert!()
