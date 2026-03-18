defmodule UhedgeCaseTecnico.Countries.Actions.GetContriesApiData do
  use Ash.Resource.Actions.Implementation

  @api "https://restcountries.com/v3.1/all?fields=name,capital,region,languages,flags"

  def run(%{arguments: %{limit: limit}}, opts, context) do
    with {:ok, %{body: body}} <- Req.get(@api) do
      body = Enum.take(body, limit)

      {:ok, Enum.map(body, &to_struct/1)}
    end
  end

  defp to_struct(country) do
    struct(UhedgeCaseTecnico.Countries.CountryOutput,
      name: country["name"],
      capital: country["capital"],
      region: country["region"],
      languages: country["languages"],
      flags: country["flags"]
    )
  end
end
