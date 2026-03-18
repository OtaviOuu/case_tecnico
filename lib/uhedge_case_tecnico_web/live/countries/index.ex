defmodule UhedgeCaseTecnicoWeb.Countries.Index do
  use UhedgeCaseTecnicoWeb, :live_view

  def mount(_params, _session, socket) do
    socket
    |> assign_contries()
    |> dbg
    |> ok()
  end

  def assign_contries(socket) do
    socket
    |> assign_async(:countries, fn ->
      {:ok, %{countries: UhedgeCaseTecnico.Countries.list_countries!(1)}}
    end)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.async_result :let={countries} assign={@countries}>
        <:loading><.contries_grid_skeleton /></:loading>
        <:failed :let={_failure}>err</:failed>
        <.contries_grid countries={countries} />
      </.async_result>
    </Layouts.app>
    """
  end

  defp contries_grid(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-4">
      <.country_card :for={country <- @countries} country={country} />
    </div>
    """
  end

  defp contries_grid_skeleton(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-4">
      <.country_card_skeleton :for={_ <- 1..9} />
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
    <div class="card bg-base-100 shadow-sm hover:shadow-lg transition-shadow duration-300 cursor-pointer">
      <figure class="h-48 overflow-hidden">
        <img
          src={@country.flags["png"]}
          alt={@country.flags["alt"]}
          class="w-full h-full object-cover"
        />
      </figure>
      <div class="card-body p-4">
        <h2 class="card-title text-lg font-bold mb-2">{@country.name["common"]}</h2>

        <div class="space-y-2 text-sm">
          <div class="flex items-start gap-2">
            <span class="font-semibold text-base-content/70 min-w-[70px]">Capital:</span>
            <span class="text-base-content">{Enum.join(@country.capital, ", ")}</span>
          </div>

          <div class="flex items-start gap-2">
            <span class="font-semibold text-base-content/70 min-w-[70px]">Region:</span>
            <span class="text-base-content">{@country.region}</span>
          </div>

          <div class="flex items-start gap-2">
            <span class="font-semibold text-base-content/70 min-w-[70px]">Languages:</span>
            <span class="text-base-content">{format_languages(@country.languages)}</span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp country_card_skeleton(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-sm animate-pulse">
      <figure class="h-48 overflow-hidden">
        <div class="w-full h-full bg-base-300"></div>
      </figure>

      <div class="card-body p-4 space-y-3">
        <div class="h-6 w-3/4 bg-base-300 rounded"></div>

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
end
