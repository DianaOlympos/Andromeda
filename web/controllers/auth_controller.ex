defmodule Andromeda.AuthController do
  use Andromeda.Web, :controller
  alias EveUser.UserDetails


  def index(conn, %{"fleet_id"=>fleet_id}) do
    redirect conn, external: Andromeda.Eve.authorize_url!(fleet_id)
  end

  def index(conn, _params) do
    redirect conn, external: Andromeda.Eve.authorize_url!()
  end

  def callback(conn, %{"code" => code, "state"=> fleet_id}) do
    token = Andromeda.Eve.get_token!(code: code)

    conn
    |> authenticate_char(token, fleet_id)
    |> redirect(to: "/fleet/"<>fleet_id)
  end

  def callback(conn, %{"code" => code}) do
    token = Andromeda.Eve.get_token!(code: code)

    conn
    |> authenticate_char(token)
    |> redirect(to: "/")
  end

  def unauthorized(conn,%{"fleet_id"=>fleet_id}) do
    conn
    |> put_flash(:info, "You are not authenticated, please log in using SSO.")
    |> redirect(to: "/auth/"<>"#{fleet_id}")
  end

  def signout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "logged out succesfully")
    |> redirect(to: "/")
  end


  defp authenticate_char(conn, token, fleet_id) do

    char_details = Evesurvey.Characterdetails.fetch_user_details(token.access_token)

    user = %UserDetails{
        id: char_details["CharacterID"],
        name: char_details["CharacterName"],
        refresh_token: token.refresh_token,
        access_token: token.access_token,
        fleet: fleet_id}

    EveUser.Registry.create(EveUser.Registry,user)

    conn
    |> Guardian.Plug.sign_in(user, :token)
    |> put_flash(:info, char_details["CharacterName"]<>" logged succesfully")
  end

  defp authenticate_char(conn, token) do

    char_details = Evesurvey.Characterdetails.fetch_user_details(token.access_token)

    user = %UserDetails{id: char_details["CharacterID"],name: char_details["CharacterName"],
     refresh_token: token.refresh_token, access_token: token.access_token}

    EveUser.Registry.create(EveUser.Registry,user)

    conn
    |> Guardian.Plug.sign_in(user, :token)
    |> put_flash(:info, char_details["CharacterName"]<>" logged succesfully")
  end

end
