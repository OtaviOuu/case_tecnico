defmodule UhedgeCaseTecnico.Countries do
  use Ash.Domain,
    otp_app: :uhedge_case_tecnico

  # name, capital, region, languages
  resources do
    resource UhedgeCaseTecnico.Countries.Country do
      define :list_countries, action: :read, args: [:limit]
    end
  end
end
