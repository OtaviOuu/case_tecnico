defmodule UhedgeCaseTecnico.Countries.Country do
  use Ash.Resource,
    otp_app: :uhedge_case_tecnico,
    domain: UhedgeCaseTecnico.Countries

  actions do
    action :read, {:array, UhedgeCaseTecnico.Countries.CountryOutput} do
      run UhedgeCaseTecnico.Countries.Actions.GetContriesApiData
    end
  end
end
