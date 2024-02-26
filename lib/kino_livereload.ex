defmodule KinoLiveReload do
  @external_resource "README.md"

  [_, readme_docs, _] =
    "README.md"
    |> File.read!()
    |> String.split("<!-- Docs -->")

  @moduledoc """
  #{readme_docs}
  """

  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]}
    }
  end

  def init(args) do
    modules = Keyword.get(args, :modules)
    cell_id = Keyword.fetch!(args, :cell_id)

    path_to_module =
      for mod <- modules, into: %{} do
        {mod.module_info(:compile)[:source] |> to_string(), mod}
      end

    paths = Map.keys(path_to_module)

    {:ok, watcher_pid} = FileSystem.start_link(dirs: paths)
    FileSystem.subscribe(watcher_pid)

    {:ok, %{watcher_pid: watcher_pid, path_to_module: path_to_module, cell_id: cell_id}}
  end

  def handle_info(
        {:file_event, watcher_pid, {path, events}},
        %{watcher_pid: watcher_pid} = state
      ) do
    module = Map.get(state.path_to_module, path, nil)
    modified? = :modified in events

    if module != nil and modified? do
      :code.purge(module)
      IEx.Helpers.r(module)

      cell_id = state.cell_id

      livebook_pids =
        Node.list(:connected)
        |> Enum.flat_map(fn n ->
          :rpc.call(n, :erlang, :processes, [])
          |> Enum.map(fn pid ->
            info = :rpc.call(n, Process, :info, [pid])
            {pid, info}
          end)
          |> Enum.filter(fn {_pid, info} ->
            case info[:dictionary][:"$initial_call"] do
              {Livebook.Session, _, _} -> true
              _ -> false
            end
          end)
          |> Enum.map(fn {pid, _} -> pid end)
        end)

      livebook_pid =
        livebook_pids
        |> Enum.find(fn pid ->
          :sys.get_state(pid)
          |> get_in(
            [:data, :cell_infos]
            |> Enum.map(&Access.key!(&1))
          )
          |> Map.get(cell_id, false)
        end)

      GenServer.cast(livebook_pid, {:queue_cell_evaluation, "LiveReloader", cell_id})

      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    # Your own logic when monitor stop
    {:noreply, state}
  end

  def handle_info(:subscribe, state) do
    {:noreply, state}
  end

  defmacro __using__(opts) do
    mods = Keyword.fetch!(opts, :watch)
    "#cell:" <> cell_id = __CALLER__.file
    mods = List.wrap(mods)

    quote do
      mods = unquote(mods)
      cell_id = unquote(cell_id)
      child_spec = KinoLiveReload.child_spec(modules: mods, cell_id: cell_id)
      {:ok, pid} = Kino.start_child(child_spec)
    end
  end
end
