defmodule UhedgeCaseTecnicoWeb.Countries.Index do
  use UhedgeCaseTecnicoWeb, :live_view

  def mount(_params, _session, socket) do
    socket
    |> assign_contries()
    |> ok()
  end

  def assign_contries(socket) do
    socket
    |> assign_async(:countries, fn ->
      {:ok, %{countries: UhedgeCaseTecnico.Countries.list_countries!(33)}}
    end)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.async_result :let={countries} assign={@countries}>
        <:loading><.contries_grid_skeleton /></:loading>
        <:failed :let={_failure}>Erro ao carregar os países.</:failed>
        <.contries_grid countries={countries} />
      </.async_result>
    </Layouts.app>
    """
  end

  defp contries_grid(assigns) do
    ~H"""
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 p-4">
      <.country_card :for={country <- @countries} country={country} />
    </div>
    """
  end

  defp contries_grid_skeleton(assigns) do
    ~H"""
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 p-4">
      <.country_card_skeleton :for={_ <- 1..12} />
    </div>
    """
  end

  defp format_languages(languages) when is_map(languages) do
    languages
    |> Map.values()
    |> Enum.join(", ")
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
          <div class="flex items-start gap-2">
            <span class="font-semibold text-base-content/70 min-w-[60px] sm:min-w-[70px]">
              Capital:
            </span>
            <span class="text-base-content line-clamp-1">
              {Enum.join(@country.capital, ", ")}
            </span>
          </div>

          <div class="flex items-start gap-2">
            <span class="font-semibold text-base-content/70 min-w-[60px] sm:min-w-[70px]">
              Region:
            </span>
            <span class="text-base-content">{@country.region}</span>
          </div>

          <div class="flex items-start gap-2">
            <span class="font-semibold text-base-content/70 min-w-[60px] sm:min-w-[70px]">
              Languages:
            </span>
            <span class="text-base-content line-clamp-2">
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
      <figure class="h-40 sm:h-44 md:h-48 overflow-hidden">
        <div class="w-full h-full bg-base-300"></div>
      </figure>

      <div class="card-body p-3 sm:p-4 space-y-2 sm:space-y-3">
        <div class="h-5 sm:h-6 w-3/4 bg-base-300 rounded"></div>

        <div class="space-y-1.5 sm:space-y-2">
          <div class="flex gap-2">
            <div class="h-3 sm:h-4 w-14 sm:w-16 bg-base-300 rounded"></div>
            <div class="h-3 sm:h-4 w-28 sm:w-32 bg-base-300 rounded"></div>
          </div>

          <div class="flex gap-2">
            <div class="h-3 sm:h-4 w-14 sm:w-16 bg-base-300 rounded"></div>
            <div class="h-3 sm:h-4 w-20 sm:w-24 bg-base-300 rounded"></div>
          </div>

          <div class="flex gap-2">
            <div class="h-3 sm:h-4 w-14 sm:w-16 bg-base-300 rounded"></div>
            <div class="h-3 sm:h-4 w-32 sm:w-40 bg-base-300 rounded"></div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
