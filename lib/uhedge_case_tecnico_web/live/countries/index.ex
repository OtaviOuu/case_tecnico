defmodule UhedgeCaseTecnicoWeb.Countries.Index do
  use UhedgeCaseTecnicoWeb, :live_view

  def mount(_params, _session, socket) do
    socket
    |> assign(:page_title, "Countries")
    |> assign(:search, "")
    |> assign(:countries, [])
    |> load_countries()
    |> ok
  end

  defp load_countries(socket) do
    assign_async(socket, :all_countries, fn ->
      {:ok, %{all_countries: UhedgeCaseTecnico.Countries.list_countries!()}}
    end)
  end

  def handle_params(params, _url, socket) do
    search =
      params
      |> Map.get("search", "")
      |> String.trim()

    case socket.assigns.all_countries do
      %{ok?: true, result: countries} ->
        filtered = filter_countries(countries, search)

        socket
        |> assign(:search, search)
        |> assign(:countries, filtered)
        |> noreply()

      _ ->
        socket
        |> assign(:search, search)
        |> noreply()
    end
  end

  def handle_event("search", %{"search" => search}, socket) do
    search = String.trim(search)

    path =
      case search do
        "" -> ~p"/"
        q -> ~p"/?search=#{q}"
      end

    {:noreply, push_patch(socket, to: path)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <form phx-change="search" class="w-full max-w-sm mx-auto mb-6">
        <label class="input">
          <.icon name="hero-magnifying-glass" class="w-5 h-5 text-base-content/70" />
          <input
            type="search"
            name="search"
            value={@search}
            placeholder="Search"
            phx-debounce="300"
          />
        </label>
      </form>

      <.async_result :let={countries} assign={@all_countries}>
        <:loading>
          <.countries_grid_skeleton />
        </:loading>

        <:failed>
          Erro ao carregar os países.
        </:failed>

        <.countries_grid countries={filter_countries(countries, @search)} />
      </.async_result>
    </Layouts.app>
    """
  end

  attr :countries, :list, required: true

  defp countries_grid(assigns) do
    ~H"""
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 p-4">
      <.country_card :for={country <- @countries} country={country} />
    </div>
    """
  end

  defp countries_grid_skeleton(assigns) do
    ~H"""
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 p-4">
      <.country_card_skeleton :for={_ <- 1..12} />
    </div>
    """
  end

  attr :country, UhedgeCaseTecnico.Countries.CountryOutput, required: true

  defp country_card(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-sm hover:shadow-lg transition-shadow duration-300 cursor-pointer h-full">
      <figure class="h-40 sm:h-44 md:h-48 overflow-hidden">
        <img
          src={@country.flags["png"]}
          alt={@country.flags["alt"]}
          class="w-full h-full object-cover"
        />
      </figure>

      <div class="card-body p-3 sm:p-4">
        <h2 class="card-title text-base sm:text-lg font-bold mb-2 line-clamp-2">
          {@country.name["common"]}
        </h2>

        <div class="space-y-1.5 sm:space-y-2 text-xs sm:text-sm">
          <div class="flex gap-2">
            <span class="font-semibold min-w-[70px]">Capital:</span>
            <span class="line-clamp-1">
              {Enum.join(@country.capital, ", ")}
            </span>
          </div>

          <div class="flex gap-2">
            <span class="font-semibold min-w-[70px]">Region:</span>
            <span>{@country.region}</span>
          </div>

          <div class="flex gap-2">
            <span class="font-semibold min-w-[70px]">Languages:</span>
            <span class="line-clamp-2">
              {format_languages(@country.languages)}
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp country_card_skeleton(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-sm animate-pulse h-full">
      <figure class="h-40 overflow-hidden">
        <div class="w-full h-full bg-base-300"></div>
      </figure>

      <div class="card-body space-y-3">
        <div class="h-5 w-3/4 bg-base-300 rounded"></div>

        <div class="space-y-2">
          <div class="flex gap-2">
            <div class="h-4 w-16 bg-base-300 rounded"></div>
            <div class="h-4 w-32 bg-base-300 rounded"></div>
          </div>
          <div class="flex gap-2">
            <div class="h-4 w-16 bg-base-300 rounded"></div>
            <div class="h-4 w-24 bg-base-300 rounded"></div>
          </div>

          <div class="flex gap-2">
            <div class="h-4 w-16 bg-base-300 rounded"></div>
            <div class="h-4 w-40 bg-base-300 rounded"></div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp filter_countries(countries, ""), do: countries

  defp filter_countries(countries, search) do
    search = String.downcase(search)

    Enum.filter(countries, fn country ->
      String.contains?(
        String.downcase(country.name["common"]),
        search
      )
    end)
  end

  defp format_languages(languages) when is_map(languages) do
    languages
    |> Map.values()
    |> Enum.join(", ")
  end
end
