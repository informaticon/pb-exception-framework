forward
global type exf1_u_exf_blob from nonvisualobject
end type
end forward

global type exf1_u_exf_blob from nonvisualobject
end type
global exf1_u_exf_blob exf1_u_exf_blob

type variables

string is_name
string is_type
blob ibl_data

//2022-05-17 Simon Reichenbach, Ticket 300164: Vertrauliche Daten nicht in der Fehlermeldung anzeigen
boolean ibo_confidential
end variables

forward prototypes
public function u_exf_blob of_clone ()
public function string of_to_string ()
end prototypes

public function u_exf_blob of_clone ();//Zweck		Erstellt eine Kopie des Blobs
//Return		u_exf_blob Instanz
//Erstellt	2022-05-17 Simon Reichenbach	Ticket 300164

u_exf_blob lu_ret
lu_ret = create u_exf_blob

lu_ret.is_type = this.is_type
lu_ret.is_name = this.is_name
lu_ret.ibl_data = this.ibl_data
lu_ret.ibo_confidential = this.ibo_confidential

return lu_ret
end function

public function string of_to_string ();//Zweck		Gibt die String-Repräsentation des Objekts zurück
//Return		string	
//Erstellt	2022-08-17 Simon Reichenbach

crypterobject lco_crypt
u_exf_serialization lu_serialization
lu_serialization = create u_exf_serialization
lco_crypt = create crypterobject

string ls_ret

ls_ret = classname(this) + ': {{{'

if isnull(is_name) then
	ls_ret += ' is_name: NULL; '
else
	ls_ret += ' is_name: "' + is_name + '"; '
end if
if isnull(is_type) then
	ls_ret += ' is_type: NULL; '
else
	ls_ret += ' is_type: "' + is_type + '"; '
end if
if isnull(ibo_confidential) then
	ls_ret += ' ibo_confidential: NULL; '
else
	ls_ret += ' ibo_confidential: ' + string(ibo_confidential) + '; '
end if
if isnull(ibl_data) then
	ls_ret += ' ibl_data(sha): NULL~r~n'
else
	try
		ls_ret += ' ibl_data(sha): ' + lu_serialization.of_hexencode(lco_crypt.sha(sha1!, ibl_data)) + '; '
	catch (u_exf_ex le_e)
		ls_ret += ' ibl_data(sha): ERR~r~n'
	end try
end if

return ls_ret + '}}}'
end function

on exf1_u_exf_blob.create
call super::create
TriggerEvent( this, "constructor" )
end on

on exf1_u_exf_blob.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//Zweck		Blob-Objekt
//				ergänzt den Datentyp blob mit zwei zusätzlichen Informationen für Bezeichnung und Typ
//				Wird unter anderem für das Exception Framework benötigt
//Erstellt 2020-11-16 Simon Reichenbach	Ticket 15230

end event

