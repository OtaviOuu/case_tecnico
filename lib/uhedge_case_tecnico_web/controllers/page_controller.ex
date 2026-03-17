defmodule UhedgeCaseTecnicoWeb.PageController do
  use UhedgeCaseTecnicoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
