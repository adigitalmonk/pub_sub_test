defmodule PubSubTest.Repo do
  use Ecto.Repo,
    otp_app: :pub_sub_test,
    adapter: Ecto.Adapters.Postgres

  require Logger

  def listen(event_name) do
    with {:ok, pid} <- Postgrex.Notifications.start_link(config()),
         {:ok, ref} <- Postgrex.Notifications.listen(pid, event_name) do
      {:ok, pid, ref}
    else
      err ->
        Logger.debug(fn -> inspect(err) end)
        {:error, :cant_listen}
    end
  end

  def unlisten(pid, ref) do
    Postgrex.Notifications.unlisten!(pid, ref)
  end
end
