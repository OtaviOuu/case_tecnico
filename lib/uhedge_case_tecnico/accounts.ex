defmodule UhedgeCaseTecnico.Accounts do
  use Ash.Domain, otp_app: :uhedge_case_tecnico, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource UhedgeCaseTecnico.Accounts.Token
    resource UhedgeCaseTecnico.Accounts.User
  end
end
