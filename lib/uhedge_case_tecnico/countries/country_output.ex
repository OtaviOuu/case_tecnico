defmodule UhedgeCaseTecnico.Countries.CountryOutput do
  use Ash.TypedStruct

  typed_struct do
    field :name, :string, allow_nil?: false
    field :capital, :string, allow_nil?: false
    field :region, :string, allow_nil?: false
    field :languages, {:array, :string}, allow_nil?: false
  end
end
