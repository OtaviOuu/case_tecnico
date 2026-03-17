defmodule UhedgeCaseTecnico.Countries.Actions.GetContriesApiData do
  use Ash.Resource.Actions.Implementation

  def run(action_input, opts, context) do
    contries = [
      %UhedgeCaseTecnico.Countries.CountryOutput{
        name: "brazil",
        capital: "brasília",
        language: "pt-br",
        region: "south america"
      },
      %UhedgeCaseTecnico.Countries.CountryOutput{
        name: "argentina",
        capital: "buenos aires",
        language: "es",
        region: "south america"
      }
    ]

    {:ok, contries}
  end
end
