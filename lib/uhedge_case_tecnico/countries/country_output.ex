defmodule UhedgeCaseTecnico.Countries.CountryOutput do
  use Ash.TypedStruct

  typed_struct do
    field :name, :map, allow_nil?: false
    field :capital, {:array, :string}, allow_nil?: false
    field :region, :string, allow_nil?: false
    field :languages, :map, allow_nil?: false
    field :flags, :map, allow_nil?: false
  end
end
