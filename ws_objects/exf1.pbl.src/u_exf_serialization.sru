$PBExportHeader$u_exf_serialization.sru
forward
global type u_exf_serialization from nonvisualobject
end type
end forward

global type u_exf_serialization from nonvisualobject
end type
global u_exf_serialization u_exf_serialization

type prototypes

end prototypes

type variables

protected coderobject pu_coder

end variables

forward prototypes
public function blob of_serialize (u_exf_blob au_blob)
public function blob of_serialize (u_exf_error_data au_data)
public function u_exf_blob of_deserialize_blob (blob abl_blob) throws u_exf_ex
public function u_exf_error_data of_deserialize_error_data (blob abl_error_data) throws u_exf_ex
protected function u_exf_error_data pf_deserialize_error_data (jsonparser ajp_parser, long al_root_handle) throws u_exf_ex
protected function u_exf_blob pf_deserialize_blob (jsonparser ajp_parser, long al_root_handle) throws u_exf_ex
public function blob of_base64decode (string as_base64)
public function string of_base64encode (blob abl_data, string as_nullvalue)
public function blob of_hexdecode (string as_hex)
public function string of_hexencode (blob abl_data)
end prototypes

public function blob of_serialize (u_exf_blob au_blob);//Zweck		Gibt einen EXF-Blob als JSON Objekt zurück
//Argument	u_exf_blob-Instanz
//Return		entsprechender blob in folgendem Format:
//							{"is_name":"Base64","is_value":"Base64","is_type":"Base64","confidential":true}
//Erstellt	2022-08-17 Simon Reichenbach
//Geändert	2023-01-26 Simon Reichenbach	Ticket 300424

blob lbl_ret

lbl_ret += blob('{"is_name":"' + of_base64encode(blob(au_blob.is_name, encodingutf8!), '') + '"', encodingutf8!)

lbl_ret += blob(',"is_type":"' + of_base64encode(blob(au_blob.is_type, encodingutf8!), '') + '"', encodingutf8!)

lbl_ret += blob(',"ibl_data":"' + of_base64encode(au_blob.ibl_data, '') + '"', encodingutf8!)

lbl_ret += blob(',"ibo_confidential":', encodingutf8!)
if au_blob.ibo_confidential then
	lbl_ret += blob('true', encodingutf8!)
else
	lbl_ret += blob('false', encodingutf8!)
end if

return lbl_ret + blob('}', encodingutf8!)

end function

public function blob of_serialize (u_exf_error_data au_data);//Zweck		Gibt ein Error-Objekt als JSON Objekt zurück
//Argument	au_data	u_exf_error_data-Instanz
//Return		blob	in folgndem Format:
//							{"blobs": [{<blob1>}, {<blob2>}, <...>]}
//Erstellt	2022-08-17 Simon Reichenbach
//Geändert	2023-01-26 Simon Reichenbach	Ticket 300424

long ll_i
blob lbl_ret
u_exf_blob lu_complex_data[]

lbl_ret += blob('{"type":"' + of_base64encode(blob(au_data.of_get_type(), encodingutf8!), '') + '"', encodingutf8!)

lbl_ret += blob(',"message":"' + of_base64encode(blob(au_data.of_get_message(), encodingutf8!), '') + '"', encodingutf8!)

lbl_ret += blob(',"message_tbz":', encodingutf8!)
if isnull(au_data.of_get_message_tbz()) then
	lbl_ret += blob('null', encodingutf8!)
else
	lbl_ret += blob(string(au_data.of_get_message_tbz()), encodingutf8!)
end if

blob lbl_keyval_store
au_data.of_get_keyval_store().getfullstate(lbl_keyval_store)
lbl_ret += blob(',"keyval_store":"' + of_base64encode(lbl_keyval_store, '') + '"', encodingutf8!)
 
lbl_ret += blob(',"blobs":[', encodingutf8!)
lu_complex_data = au_data.of_get_complex_data()
for ll_i = 1 to upperbound(lu_complex_data)
	lbl_ret += of_serialize(lu_complex_data[ll_i])
	if ll_i < upperbound(lu_complex_data) then
		lbl_ret +=  blob(',', encodingutf8!)
	end if
next
lbl_ret += blob(']', encodingutf8!)

if isvalid(au_data.of_get_nested_error()) then
	//has_nested_error is needed for the deserialization. If you don't like it, go and ask
	//Appeon why their shitty JSON Library is such a crap that it even can't check if a key exists
	lbl_ret += blob(',"has_nested_error":true', encodingutf8!) 
	lbl_ret += blob(',"nested_error":', encodingutf8!) + of_serialize(au_data.of_get_nested_error())
else
	lbl_ret += blob(',"has_nested_error":false', encodingutf8!) 
end if

return lbl_ret + blob('}', encodingutf8!)
end function

public function u_exf_blob of_deserialize_blob (blob abl_blob) throws u_exf_ex;//Zweck		Deserialisiert einen EXF-Blob aus einem JSON Objekt
//Argument	abl_blob	in folgndem Format:
//							{"is_name":"Base64","is_value":"Base64","is_type":"Base64","confidential":true}
//Return		Entsprechende u_exf_blob-Instanz
//Erstellt	2022-08-17 Simon Reichenbach

string ls_error
long ll_handle
jsonparser ljp_parser
ljp_parser = create jsonparser

ls_error = ljp_parser.loadstring(string(abl_blob, encodingutf8!))
if len(ls_error) > 0 then
	throw(gu_e.iu_as.of_ex(gu_e.of_new_error() &
		.of_push(populateerror(0, 'JSON-String could not be loaded')) &
		.of_push('abl_blob', abl_blob) &
		.of_push('ls_error', ls_error) &
	))
end if

ll_handle = ljp_parser.getrootitem()
return pf_deserialize_blob(ljp_parser, ll_handle)

end function

public function u_exf_error_data of_deserialize_error_data (blob abl_error_data) throws u_exf_ex;//Zweck		Deserialisiert einen Error-Data-Objekt aus einem JSON Objekt
//Argument	abl_error_data	in folgndem Format (ohne Zeilenumbrüche/Whitespace):
//							{"type":"Base64","message":"Base64","message_tbz":<number>,
//							"keyval_store":"Base64","blobs":[{<u_exf_blob-JSON>}],"nested_exception":{<u_exf_error_data-JSON>}}
//Return		Entsprechende u_exf_error_data-Instanz
//Erstellt	2022-08-17 Simon Reichenbach

string ls_error
jsonparser ljp_parser
ljp_parser = create jsonparser

ls_error = ljp_parser.loadstring(string(abl_error_data, encodingutf8!))
if len(ls_error) > 0 then
	throw(gu_e.iu_as.of_ex(gu_e.of_new_error() &
		.of_push(populateerror(0, 'JSON-String could not be loaded')) &
		.of_push('abl_error_data', abl_error_data) &
		.of_push('ls_error', ls_error) &
	))
end if

return pf_deserialize_error_data(ljp_parser, ljp_parser.getrootitem())
end function

protected function u_exf_error_data pf_deserialize_error_data (jsonparser ajp_parser, long al_root_handle) throws u_exf_ex;//Zweck		Deserialisiert einen Error-Data-Objekt aus einem JSON Objekt
//Argument	abl_error_data	in folgndem Format (ohne Zeilenumbrüche/Whitespace):
//							{"type":"Base64","message":"Base64","message_tbz":<number>,
//							"keyval_store":"Base64","blobs":[{<u_exf_blob-JSON>}],"nested_exception":{<u_exf_error_data-JSON>}}
//Return		Entsprechende u_exf_error_data-Instanz
//Erstellt	2022-08-17 Simon Reichenbach

long ll_blob_array_handle
long ll_blob_array_count
long ll_i
blob lbl_keyval_store
datastore lds_keyval_store
u_exf_error_data lu_ret
lds_keyval_store = create datastore
lu_ret = create u_exf_error_data

lu_ret.of_set_type(string(of_base64decode(ajp_parser.getitemstring(al_root_handle, 'type')), encodingutf8!))
lu_ret.of_set_message( &
	ajp_parser.getitemnumber(al_root_handle, 'message_tbz'), &
	string(of_base64decode(ajp_parser.getitemstring(al_root_handle, 'message')), encodingutf8!) &
)

lbl_keyval_store = of_base64decode(ajp_parser.getitemstring(al_root_handle, 'keyval_store'))
if lds_keyval_store.setfullstate(lbl_keyval_store) < 0 then
	throw(gu_e.iu_as.of_ex(gu_e.of_new_error() &
		.of_push(populateerror(0, 'Key-Value-Store could not be recreated')) &
		.of_push('lbl_keyval_store', lbl_keyval_store) &
	))
end if
lu_ret.of_set_keyval_store(lds_keyval_store)

ll_blob_array_handle = ajp_parser.getitemarray(al_root_handle, 'blobs')
ll_blob_array_count = ajp_parser.getchildcount(ll_blob_array_handle)
for ll_i = 1 to ll_blob_array_count
	lu_ret.of_push(pf_deserialize_blob(ajp_parser, ajp_parser.getchilditem(ll_blob_array_handle, ll_i)))
next

if ajp_parser.getitemboolean(al_root_handle, 'has_nested_error') then
	lu_ret.of_set_nested_error( &
		pf_deserialize_error_data(ajp_parser, ajp_parser.getitemobject(al_root_handle, 'nested_error')) &
	)
end if

return lu_ret
end function

protected function u_exf_blob pf_deserialize_blob (jsonparser ajp_parser, long al_root_handle) throws u_exf_ex;//Zweck		Deserialisiert einen EXF-Blob aus einem JSON Objekt
//Argument	ajp_parser			Bereits instanziierter Parser mit geladenem JSON Objekt
//				al_root_handle		Handle, der auf den Root-Node zeigt
//Return		Entsprechende u_exf_blob-Instanz
//Erstellt	2022-08-17 Simon Reichenbach

u_exf_blob lu_ret
lu_ret = create u_exf_blob

lu_ret.is_name = string(of_base64decode(ajp_parser.getitemstring(al_root_handle, 'is_name')), encodingutf8!)
lu_ret.is_type = string(of_base64decode(ajp_parser.getitemstring(al_root_handle, 'is_type')), encodingutf8!)
lu_ret.ibo_confidential = ajp_parser.getitemboolean(al_root_handle, 'ibo_confidential')
lu_ret.ibl_data = of_base64decode(ajp_parser.getitemstring(al_root_handle, 'ibl_data'))

return lu_ret

end function

public function blob of_base64decode (string as_base64);//Zweck		Konvertiert Base64 string zu Binärdaten (blob)
//Erstellt	2023-01-26 Simon Reichenbach	Ticket 300424

return pu_coder.base64decode(as_base64)
end function

public function string of_base64encode (blob abl_data, string as_nullvalue);//Zweck		Konvertiert einen blob (Binärdaten) in einen Base64-String
//Argument	abl_data			Binärdaten
//			as_nullvalue	Alternativer Wert, welcher zurückgegeben wird wenn abl_data NULL ist
//Return	Base64-String (z.B. 'QUJDRA==')
//Erstellt	2023-01-26 Simon Reichenbach	Ticket 300424

if isnull(abl_data) then
	return as_nullvalue
end if

return pu_coder.base64encode(abl_data)

end function

public function blob of_hexdecode (string as_hex);//Zweck		Konvertiert einen Hex-String in einen blob (Binärdaten)
//Erstellt	2023-01-26 Simon Reichenbach	Ticket 300424

return pu_coder.hexdecode(as_hex)
end function

public function string of_hexencode (blob abl_data);//Zweck		Konvertiert einen blob (Binärdaten) in einen Hex-String
//Argument	abl_data	Binärdaten
//Return	Hex-String (z.B. 'A1B2C3D4E5')
//Erstellt	2023-01-26 Simon Reichenbach	Ticket 300424

return pu_coder.hexencode(abl_data)

end function

on u_exf_serialization.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_exf_serialization.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;pu_coder = create coderobject
end event

