defmodule PubSubTest.Listener do
  use GenServer
  alias PubSubTest.Repo
  alias PubSubTest.User

  def start_link(opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def init(_opts) do
    case Repo.listen("user_changed") do
      {:ok, pid, ref} ->
        # If the listening connection goes down, crash this process
        Process.monitor(pid)
        {:ok, %{ref: ref, pid: pid}}
      {:error, error} ->
        {:stop, error}
    end
  end

  def handle_info({:notification, _pid, _ref, "user_changed", payload}, state) do
    with {:ok, %{"before" => pre, "after" => post, "operation" => op }} <- Jason.decode(payload) do

      # User data from before the change
      pre_user =
        case pre do
          nil -> nil
          pre_data ->
            pre_data
            |> User.changeset()
            |> User.apply()
            |> then(fn {:ok, user} -> user end)
        end

      # User data from after the change
      post_user =
        case post do
          nil -> nil
          post_data ->
            post_data
            |> User.changeset()
            |> User.apply()
            |> then(fn {:ok, user} -> user end)
        end

      IO.inspect(%{pre: pre_user, post: post_user, op: op}, label: :received)
    else
      _ ->
        IO.inspect(payload, label: :unparseable)
    end

    {:noreply, state}
  end

  def handle_info(payload, state) do
    IO.inspect(payload, label: :unhandled)
    {:noreply, state}
  end

  def terminate(_reason, %{ref: ref, pid: pid}) do
    Repo.unlisten(pid, ref)
    :ok
  end
end
