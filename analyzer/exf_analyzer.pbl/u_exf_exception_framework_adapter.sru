forward
global type u_exf_exception_framework_adapter from u_exf_application_adapter
end type
end forward

global type u_exf_exception_framework_adapter from u_exf_application_adapter
end type
global u_exf_exception_framework_adapter u_exf_exception_framework_adapter

type variables
protected string ps_oauth_token_url = ''
protected string ps_oauth_client_id = ''
protected string ps_oauth_client_secret = ''
protected string ps_oauth_scope = ''
end variables

forward prototypes
public function u_exf_error_data of_download (string as_name, string as_key) throws u_exf_ex
end prototypes

public function u_exf_error_data of_download (string as_name, string as_key) throws u_exf_ex;//Zweck		Lädt eine Exception von einem Onlinestorage herunter
//			Abstrakte Funktion, muss in höheren Schichten implementiert werden
//Argument	as_name	Name der Exception (z.B. 2022-08-17_12-23_12321)
//			as_key	Schlüssel, welcher zum Verschlüsseln der Exception verwendet wurde
//					als HEX String (z.B. '0A1B2C3D4E5F6789')
//Return	u_exf_error_data	heruntergeladene und entschlüsselte Exception
//Throws	u_exf_ex			Falls ein Fehler auftritt
//Erstellt	2023-08-02 Simon Reichenbach

blob lbl_data
blob lbl_key
string ls_token
string ls_body

crypterobject lco_crypt; lco_crypt = create crypterobject
oauthclient lu_oauthcli; lu_oauthcli = create oauthclient
tokenrequest lu_tkreq
tokenresponse lu_tkresp
oauthrequest lu_oauthreq
resourceresponse lu_resresp

// get bearer token
lu_tkreq.tokenlocation = ps_oauth_token_url
lu_tkreq.method = 'POST'
lu_tkreq.secureprotocol = 0
lu_tkreq.clientid = ps_oauth_client_id
lu_tkreq.clientsecret = ps_oauth_client_secret
lu_tkreq.scope = ps_oauth_scope
lu_tkreq.granttype = 'client_credentials'
if lu_oauthcli.accesstoken(lu_tkreq, lu_tkresp) = 1 and lu_tkresp.getstatuscode() = 200 then
	if lu_tkresp.getbody(ls_body) = 1 then
		ls_token = lu_tkresp.getaccesstoken()
	else
		throw(gu_e.iu_as.of_ex(gu_e.of_new_error().of_push(populateerror(0, 'could not read response body from oauth request'))))
	end if
else
	lu_tkresp.getbody(ls_body)
	throw(gu_e.iu_as.of_ex(gu_e.of_new_error() &
		.of_push(populateerror(0, 'could not get access token')) &
		.of_push('statuscode',  lu_tkresp.getstatuscode()) &
		.of_push('responsebody',  ls_body) &
	))
end if

// download exception
lu_oauthreq.method = 'GET'
lu_oauthreq.url = ps_exception_server_url + '/' + as_name
lu_oauthreq.setaccesstoken(ls_token)
if lu_oauthcli.requestresource(lu_oauthreq, lu_resresp) = 1 and lu_resresp.getstatuscode() = 200 then
	if lu_resresp.getbody(lbl_data) = 1 then
		// ok
	else
		throw(gu_e.iu_as.of_ex(gu_e.of_new_error().of_push(populateerror(0, 'could not read response body from exctpion download'))))
	end if
else
	throw(gu_e.iu_as.of_ex(gu_e.of_new_error() &
		.of_push(populateerror(0, 'could not download exception')) &
		.of_push('statuscode',  lu_resresp.getstatuscode()) &
	))
end if

// decrypt and deserialize
lbl_key = pu_serialization.of_hexdecode(as_key)
lbl_data = lco_crypt.symmetricdecrypt( &
	aes!, &
	lbl_data, &
	blobmid(lco_crypt.sha(sha256!, lbl_key), 1, 256) &
)
return pu_serialization.of_deserialize_error_data(lbl_data)




end function

on u_exf_exception_framework_adapter.create
call super::create
end on

on u_exf_exception_framework_adapter.destroy
call super::destroy
end on

event constructor;call super::constructor;of_enable_auto_upload(false)
end event

