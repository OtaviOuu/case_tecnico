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

  attr :country, UhedgeCaseTecnico.Countries.CountryOutput, required: true

  defp country_card(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-sm hover:shadow-md cursor-pointer">
      <figure>
        <img src={@country.flags["png"]} alt={@country.flags["alt"]} />
      </figure>
      <div class="card-body">
        <h2 class="card-title">{@country.name["common"]}</h2>
        <h3 class="card-title">{@country.name["common"]}</h3>
      </div>
    </div>
    """
  end

  defp country_card_skeleton(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-sm animate-pulse">
      <figure>
        <div class="w-full h-40 bg-base-300"></div>
      </figure>

      <div class="card-body space-y-2">
        <div class="h-5 w-3/4 bg-base-300 rounded"></div>
        <div class="h-5 w-1/2 bg-base-300 rounded"></div>
      </div>
    </div>
    """
  end
end
