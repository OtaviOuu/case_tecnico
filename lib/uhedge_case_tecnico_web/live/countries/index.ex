defmodule UhedgeCaseTecnicoWeb.Countries.Index do
  use UhedgeCaseTecnicoWeb, :live_view

  def mount(_params, _session, socket) do
    socket
    |> assign_contries()
    |> dbg
    |> ok()
  end

  def assign_contries(socket) do
    countries = UhedgeCaseTecnico.Countries.list_countries!(1)
    assign(socket, countries: countries)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.contries_grid countries={@countries} />
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

  attr :country, UhedgeCaseTecnico.Countries.CountryOutput, required: true

  defp country_card(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-sm">
      <figure>
        <img
          src="https://img.daisyui.com/images/stock/photo-1606107557195-0e29a4b5b4aa.webp"
          alt="Shoes"
        />
      </figure>
      <div class="card-body">
        <h2 class="card-title">{@country.name}</h2>
        <p>{@country.capital} - {@country.region} - {@country.languages}</p>
      </div>
    </div>
    """
  end
end
