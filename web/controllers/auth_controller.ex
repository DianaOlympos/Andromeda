defmodule Andromeda.AuthController do
  use Andromeda.Web, :controller

  def index(conn, _params) do
    redirect conn, external: Eve.authorize_url!()
  end

  def callback(conn, %{"code" => code}) do
    token = Eve.get_token!(code: code)

    conn
    |> authenticate_char(token)
    |> redirect(to: "/")

  end

  def unauthorized(conn,_params) do
    conn
    |> put_flash(:info, "You are not authorized to access these assets. If this is an error, contact Diana Olympos.")
    |> redirect(to: "/")
  end

  def signout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "logged out succesfully")
    |> redirect(to: "/")
  end

  defp authenticate_char(conn, token) do

    char_details = Evesurvey.Characterdetails.fetch_user_details(token.access_token)

    user = %UserDetails{id:char_details["CharacterID"],name:char_details["CharacterName"],
     refresh_token:token.refresh_token, access_token: token.access_token}

    EveUser.Registry.create(EveUser.Registry,user)

    conn
    |> sign_in_user(token, char_details)
    |> Guardian.Plug.sign_in(user, :token)
    |> put_flash(:info, char_details["CharacterName"]<>" logged succesfully")

  end

end

end
