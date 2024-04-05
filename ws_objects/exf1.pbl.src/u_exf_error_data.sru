$PBExportHeader$u_exf_error_data.sru
$PBExportComments$Hallo Welt
forward
global type u_exf_error_data from nonvisualobject
end type
end forward

global type u_exf_error_data from nonvisualobject
end type
global u_exf_error_data u_exf_error_data

type variables
constant string CS_KEY_STACKTRACE = 'error.stacktrace'

protected string ps_type //Exception/RuntimeError-Typ

protected string ps_message //Fehlermeldung
protected long pl_message_tbz //Fehlermeldung als Sprachtext

protected datastore pds_keyval_store //Key-Value-Daten (Zusätzliche Eigenschaften)
protected u_exf_blob pu_complex_data[] //Zusätzliche Eigenschaften (beliebige Daten, z.B. Files oder Datawindows)

protected u_exf_error_data pu_nested_error //Eingebettete Exception/RuntimeError (Exception Wrapping)


string CS_COMPLEX_DATA_DATAOBJECT = 'dataobject'
string CS_COMPLEX_DATA_UNDEFINED = ''
string CS_COMPLEX_DATA_STRING = 'string'
end variables

forward prototypes
public function u_exf_error_data of_set_message (string as_message)
public function u_exf_error_data of_set_type (string as_type)
public function u_exf_error_data of_set_message (long al_message_tbz)
public function u_exf_error_data of_set_nested_error (u_exf_error_data au_error)
public function u_exf_error_data of_set_nested_error (u_exf_ex au_exception)
public function u_exf_error_data of_set_nested_error (u_exf_re au_runtimeerror)
public function u_exf_error_data of_set_message (long al_message_tbz, string as_message)
public function u_exf_error_data of_push (string as_key, any aa_value)
public function u_exf_error_data of_push (string as_keys[], any aa_values[])
public function u_exf_error_data of_push (u_exf_blob au_complex_data)
public function u_exf_error_data of_push (string as_description, blob abl_complex_data)
public function u_exf_error_data of_push (long al_populateerror_returnvalue)
public function long of_get_message_tbz ()
public function string of_get_message ()
public function any of_get_complex_data ()
public function datastore of_get_keyval_store ()
public function u_exf_error_data of_get_nested_error ()
public function any of_get_dump ()
public function boolean of_has_complex_data ()
public function boolean of_has_nested_error ()
public function string of_get_type ()
public function u_exf_error_data of_push (string as_description, powerobject apo_data)
public function string of_get_value (string as_key)
protected function string pf_enum_to_string (any apo_enum)
public function u_exf_error_data of_push (string as_key, dwbuffer adwbuffer_value)
protected function long pf_get_keyval_row (string as_key)
public function string of_to_string ()
public function u_exf_error_data of_set_nested_error (throwable ath_throwable)
public function u_exf_error_data of_set_stacktrace ()
public function string of_get_stacktrace ()
public function u_exf_error_data of_set_keyval_store (datastore ads_keyval_store)
public function blob of_get_value (string as_name, string as_type)
public function string of_get_as_string ()
end prototypes

public function u_exf_error_data of_set_message (string as_message);//Zweck		Nimmt die Fehlermeldung der künftigen Exception/RuntimeError entegegen
//Argument	as_message	Fehlermeldung
//Return		u_exf_error_data	this
//Erstellt	2020-07-10 Simon Reichenbach

ps_message = as_message

return this
end function

public function u_exf_error_data of_set_type (string as_type);//Zweck		Setzt den Typ des Fehlers.
//				Dies wird normalerweise automatisch	beim Instanziieren der Exception/RuntimeError augerufen.
//Argument	as_type	Klassenname der Exception/RuntimeError
//Return		u_exf_error_data	this
//Erstellt	2020-11-16 Simon Reichenbach

ps_type = as_type

return this
end function

public function u_exf_error_data of_set_message (long al_message_tbz);//Zweck		Nimmt die Fehlermeldung der künftigen Exception/RuntimeError entegegen
//Argument	al_message_tbz	Fehlermeldung als Sprachtext
//Return		u_exf_error_data	this
//Erstellt	2020-07-10 Simon Reichenbach

pl_message_tbz = al_message_tbz

return this
end function

public function u_exf_error_data of_set_nested_error (u_exf_error_data au_error);//Zweck		Ein u_exf_error_data-Objekt kann in einem anderen u_exf_error_data-Objekt
//				gespeichert werden (Exception Wrapping).
//Argument	au_error			Error-Daten, welche in diesem Objekt gespeichert werden soll
//Return		u_exf_error_data	this
//Erstellt	2020-11-16 Simon Reichenbach

pu_nested_error = au_error

return this
end function

public function u_exf_error_data of_set_nested_error (u_exf_ex au_exception);//Zweck		Ein u_exf_error_data-Objekt kann in einem anderen u_exf_error_data-Objekt
//				gespeichert werden (Exception Wrapping).
//				ACHTUNG: Es wird nicht die Exception, sondern nur deren Inhalt (u_exf_error_data-Objekt) gespeichert
//Argument	au_exception	Exception mit Error-Daten, welche in diesem Objekt gespeichert werden sollen
//Return		u_exf_error_data	this
//Erstellt	2020-11-16 Simon Reichenbach

pu_nested_error = au_exception.of_get_error()

return this
end function

public function u_exf_error_data of_set_nested_error (u_exf_re au_runtimeerror);//Zweck		Ein u_exf_error_data-Objekt kann in einem anderen u_exf_error_data-Objekt
//				gespeichert werden (Exception Wrapping).
//				ACHTUNG: Es wird nicht die Exception, sondern nur deren Inhalt (u_exf_error_data-Objekt) gespeichert
//Argument	au_runtimeerror	RuntimeError mit Error-Daten, welche in diesem Objekt gespeichert werden sollen
//Return		u_exf_error_data	this
//Erstellt	2020-11-16 Simon Reichenbach

pu_nested_error = au_runtimeerror.of_get_error()

return this
end function

public function u_exf_error_data of_set_message (long al_message_tbz, string as_message);//Zweck		Nimmt die Fehlermeldung der künftigen Exception/RuntimeError entegegen
//Argument	as_message		Fehlermeldung
//				al_message_tbz	Fehlermeldung als Sprachtext
//Return		u_exf_error_data	this
//Erstellt	2020-07-10 Simon Reichenbach

ps_message = as_message
pl_message_tbz = al_message_tbz

return this
end function

public function u_exf_error_data of_push (string as_key, any aa_value);//Zweck		Nimmt einen Key und Value entegegen, welche später wieder ausgegeben werden kann
//Argument	as_key	Bezeichner (z.B. Variablenname), maximal 256 Zeichen
//				aa_value	Wert zu as_key, muss in einen string mit maximal 5000 Zeichen konvertiert werden
//							können (date, datetime, numeric, time, or string)
//Return		u_exf_error_data	this
//Erstellt	2020-11-16 Simon Reichenbach

powerobject lpo_value
long ll_row
long ll_i = 0

if isnull(as_key) then as_key = ''
if isnull(aa_value) then aa_value = ''

//2022-08-17 Simon Reichenbach, Workaround für Compiler-Fehler
//In bestimmten Situation verwendet der Compiler fälschlicherweise of_push(string, any) statt
//of_push(string, powerobject), deshalb hier versuch auf Casting zu powerobject
try
	lpo_value = aa_value
	return of_push(as_key, lpo_value)
catch(runtimeerror lr_e)
	// nothing to do, weiterfahren mit nicht-PowerObject-Funktion
end try

//Falls Wert bereits in Key-Value-Store vorhanden ist, müsste man diesen eigentlich überschreiben
//Allerdings könnte das zu einem Informationsverlust führen, deshalb bestehender Key umbenennen
ll_row = pf_get_keyval_row(as_key)
if ll_row > 0 then
	//freien Key suchen
	do until pf_get_keyval_row(as_key + string(ll_i)) = 0
		ll_i++
	loop
	pds_keyval_store.setitem(ll_row, 'key', as_key + string(ll_i))
end if

//Wert hinzufügen
ll_row = pds_keyval_store.insertrow(0)
pds_keyval_store.setitem(ll_row, 1, as_key)
pds_keyval_store.setitem(ll_row, 2, string(aa_value))

return this
end function

public function u_exf_error_data of_push (string as_keys[], any aa_values[]);//Zweck		Nimmt mehrere Keys und Values entegegen, welche später wieder ausgegeben werden kann
//Argument	as_keys[]	Array von Bezeichnern (z.B. Variablennamen)
//				as_values[]	Werte zu den as_keys
//Return		u_exf_error_data	this
//Erstellt	2020-07-10 Simon Reichenbach

long ll_i

//Sicherstellen, dass es für jeden Value einen Key gibt
do while upperbound(as_keys) < upperbound(aa_values)
	as_keys[upperbound(as_keys) + 1] = 'NULL_KEY'
loop

//Keys & Values hinzufügen
for ll_i = lowerbound(as_keys) to upperbound(as_keys)
	if  upperbound(aa_values) < ll_i then
		of_push(as_keys[ll_i], 'NULL_VALUE')
	else
		of_push(as_keys[ll_i], aa_values[ll_i])		
	end if
next

return this
end function

public function u_exf_error_data of_push (u_exf_blob au_complex_data);//Zweck		Nimmt einen Blob entegegen, welcher später wieder ausgegeben werden kann
//Argument	au_complex_data	u_exf_blob-Instanz mit beliebigen komplexen Daten, z.B. XML-String
//Return		u_exf_error_data	this
//Erstellt	2020-11-16 Simon Reichenbach

pu_complex_data[upperbound(pu_complex_data) + 1] = au_complex_data

return this

end function

public function u_exf_error_data of_push (string as_description, blob abl_complex_data);//Zweck		Nimmt einen Blob entegegen, welcher später wieder ausgegeben werden kann
//Argument	au_complex_data	u_exf_blob-Instanz mit beliebigen komplexen Daten, z.B. XML-String
//Return		u_exf_error_data	this
//Erstellt	2020-11-16 Simon Reichenbach

u_exf_blob lu_blob
lu_blob = create u_exf_blob

lu_blob.is_name = as_description
lu_blob.ibl_data = abl_complex_data
lu_blob.is_type = CS_COMPLEX_DATA_UNDEFINED

return of_push(lu_blob)
end function

public function u_exf_error_data of_push (long al_populateerror_returnvalue);//Zweck		Fügt die Daten eines error-Objekts der Exception/RuntimeError hinzu
//				Das error-Objekt ist eine globale Variable, welche mit populateerror(int, string)
//				abgefüllt werden kann und hat nichts mit u_exf_error_data zu tun
//Argument	al_populateerror_returnvalue	returnvalue von populateerror(int, string)
//Return		u_exf_error_data	this
//Erstellt	2020-11-16 Simon Reichenbach

of_push('error.populaterrorreturnvalue', al_populateerror_returnvalue)
of_push('error.number', error.number)
of_push('error.text', error.text)
of_push('error.windowmenu', error.windowmenu)
of_push('error.object', error.object)
of_push('error.objectevent', error.objectevent)
of_push('error.line', error.line)

if len(ps_message) = 0 then
	ps_message = error.text
end if

return this

end function

public function long of_get_message_tbz ();//Zweck		Getter für den Sprachtext der Fehlermeldung
//Return		long	
//Erstellt	2020-11-16 Simon Reichenbach

return pl_message_tbz
end function

public function string of_get_message ();//Zweck		Getter für die Fehlermeldung
//Return		string	
//Erstellt	2020-11-16 Simon Reichenbach

return ps_message
end function

public function any of_get_complex_data ();//Zweck		Getter für die in u_exf_error_data enthaltenen komplexen Daten
//Return		any	u_exf_blob-Array
//Erstellt	2020-11-16 Simon Reichenbach

return pu_complex_data

end function

public function datastore of_get_keyval_store ();//Zweck		Getter für den Key-Value-Store
//Return		datastore	d_keyval_store
//Erstellt	2020-11-16 Simon Reichenbach

return pds_keyval_store

end function

public function u_exf_error_data of_get_nested_error ();//Zweck		Getter für die eingebettete Exception/RuntimeError
//Return		u_exf_error_data	eingebette Exception/RuntimeError (Exception Wrapping)
//Erstellt	2020-11-16 Simon Reichenbach

return pu_nested_error

end function

public function any of_get_dump ();//Zweck		Getter für alle Daten, welche in der u_exf_error_data vorhanden sind
//				Nested Exceptions/RuntimeErrors werden beim Dump nicht mitgeliefert
//				und müssen mittels of_get_nested_error().of_get_dump() zusätzlich ermittelt werden
//Return		any	u_exf_blob-Arry mit allen Daten
//Erstellt	2020-11-16 Simon Reichenbach
//Geändert	2022-05-17 Simon Reichenbach	Ticket 300164

long ll_i
u_exf_blob lu_ret[]

lu_ret[1] = create u_exf_blob
lu_ret[1].is_type = CS_COMPLEX_DATA_STRING
lu_ret[1].is_name = 'message'
lu_ret[1].ibl_data = blob(ps_message, encodingutf8!)

lu_ret[2] = create u_exf_blob
lu_ret[2].is_type = CS_COMPLEX_DATA_STRING
lu_ret[2].is_name = 'message_tbz'
lu_ret[2].ibl_data = blob(string(pl_message_tbz), encodingutf8!)

lu_ret[3] = create u_exf_blob
lu_ret[3].is_type = CS_COMPLEX_DATA_STRING
lu_ret[3].is_name = 'type'
lu_ret[3].ibl_data = blob(ps_type, encodingutf8!)

lu_ret[4] = create u_exf_blob
lu_ret[4].is_type = CS_COMPLEX_DATA_DATAOBJECT
lu_ret[4].is_name = 'key-value-store'
pds_keyval_store.getfullstate(lu_ret[4].ibl_data)

for ll_i = 1 to upperbound(pu_complex_data)
	lu_ret[upperbound(lu_ret) + 1 ] = pu_complex_data[ll_i].of_clone()
next

return lu_ret

end function

public function boolean of_has_complex_data ();//Zweck		Gibt an, ob komplexe Daten (u_exf_blob-Instanzen) in u_exf_error_data vorhanden sind
//Return		boolean	true	beinhaltet mindestens einen u_exf_blob
//							false	sonst
//Erstellt	2020-11-16 Simon Reichenbach

return upperbound(pu_complex_data) > 0
end function

public function boolean of_has_nested_error ();//Zweck		Gibt an, ob eine eingebettete Exception/RuntimeError (u_exf_error_data-Instanzen)
//				in u_exf_error_data vorhanden sind
//Return		boolean	true	es gibt eine Nested Exception/RuntimeError
//							false	sonst
//Erstellt	2020-11-16 Simon Reichenbach

return isvalid(pu_nested_error)
end function

public function string of_get_type ();//Zweck		Getter für den Exception/RuntimeError-Typ,
//				welcher mit dem u_exf_error_data-Objekt beschrieben wird
//Return		string	(z.B. 'u_exf_re_messagebox')
//Erstellt	2020-11-16 Simon Reichenbach

return ps_type
end function

public function u_exf_error_data of_push (string as_description, powerobject apo_data);//Zweck		Nimmt ein PowerObject entegegen, welches später wieder ausgegeben werden kann
//Argument	as_description	Bezeichner (z.B. Variablenname)
//			apo_data	Wert zu as_description, muss eines der folgenden Elemente sein:
//						datawindow	Wird mittels getfullstate() in einen u_exf_blob konvertiert
//						datastore	Wird mittels getfullstate() in einen u_exf_blob konvertiert
//						object		Sollte die Funktion of_to_string() : string implementiert haben
//Return	u_exf_error_data	this
//Erstellt	2020-11-17 Simon Reichenbach
//Geändert	2021-02-22 Simon Reichenbach	Ticket 19330: apo_data sollte auch NULL sein können, ohne dass es zu einem Fehler kommt
//			2022-03-31 Simon Reichenbach	Ticket 21348: Objektparsing in den Application-Adapter migriert

u_exf_blob lu_blob

if isnull(as_description) then as_description = ''

lu_blob = gu_e.of_get_app_adapter().of_parse_to_blob(apo_data)
lu_blob.is_name = as_description

of_push(lu_blob)

return this


end function

public function string of_get_value (string as_key);//Zweck		Gibt einen bestimmten Value zu einem Key zurück (Key-Value-Store)
//				Falls ein Key mehrfach vorkommt, wird der letzte passende Wert zurückgegeben
//Argument	as_key	
//Return		string	Value zum Key, falls Key existiert
//							Leerstring sonst
//Erstellt	2020-11-17 Simon Reichenbach

long ll_row

ll_row = pds_keyval_store.find("key='" + as_key + "'", pds_keyval_store.rowcount(), 1) 
if ll_row > 0 then
	return pds_keyval_store.getitemstring(ll_row, 'value')
else
	return ''
end if

end function

protected function string pf_enum_to_string (any apo_enum);dwbuffer ldwbuffer_enum

choose case lower(classname(apo_enum))
	case 'dwbuffer'
		ldwbuffer_enum = apo_enum
		choose case ldwbuffer_enum
			case primary!
				return 'primary!'
			case delete!
				return 'delete!'
		end choose
end choose
end function

public function u_exf_error_data of_push (string as_key, dwbuffer adwbuffer_value);//Zweck		Nimmt einen Key und Value entegegen, welche später wieder ausgegeben werden kann
//Argument	as_key	Bezeichner (z.B. Variablenname), maximal 256 Zeichen
//				adwbuffer_value	DWBuffer Enumerator
//Return		u_exf_error_data	this
//Erstellt	2020-12-28 Simon Reichenbach

choose case adwbuffer_value
	case primary!
		return of_push(as_key, 'primary!')
	case delete!
		return of_push(as_key, 'delete!')
	case filter!
		return of_push(as_key, 'filter!')
	case else
		return of_push(as_key, 'unkown debuffer type')
end choose

end function

protected function long pf_get_keyval_row (string as_key);//Zweck		Ermittelt die Zeile im Key-Value-Store, in welcher sich ein bestimmter Key befindet
//Argument	as_key	Gesuchter Key
//Return		long	n Zeile, in welcher sich der Key befindet
//						0 falls Key nicht gefunden wurde
//Erstellt	2020-11-17 Simon Reichenbach

return pds_keyval_store.find("key='" + as_key + "'", pds_keyval_store.rowcount(), 1) 
end function

public function string of_to_string ();//Zweck		Fehlermeldung als String mit Key/Values
//				Eingebettete Daten (nur bei EXF-Fehlern)
//Return		string
//Erstellt	2021-12-02 Martin Abplanalp	Ticket 20951
//Geändert	2022-03-31 Simon Reichenbach	Ticket 21348
//				2022-08-18 Simon Reichenbach	Ticket 300424
long ll_i
string ls_ret
u_exf_blob lu_err[]
u_exf_error_data lu_nested

if isnull(ps_type) then
	ls_ret = classname(this) + ': {{{'
else
	ls_ret = classname(this) + '(' + ps_type + '): {{{'
end if

if isnull(ps_message) then
	ls_ret += 'NULL/'
else
	ls_ret += ps_message + '/'
end if

if isnull(pl_message_tbz) then
	ls_ret += 'NULL; '
else
	ls_ret += string(pl_message_tbz) + '; '
end if

ls_ret += ' VALUES: [[['
for ll_i = 1 to pds_keyval_store.rowcount()
	if isnull(pds_keyval_store.getitemstring(ll_i, 1)) then
		ls_ret += 'NULL'
	else
		ls_ret += pds_keyval_store.getitemstring(ll_i, 1)
	end if
	ls_ret += ' = '
	if isnull(pds_keyval_store.getitemstring(ll_i, 2)) then
		ls_ret += 'NULL'
	else
		ls_ret += pds_keyval_store.getitemstring(ll_i, 2)
	end if
	ls_ret += '; '
next
ls_ret += ']]]; COMPLEXES: [[['
for ll_i = 1 to upperbound(pu_complex_data)
	ls_ret += pu_complex_data[ll_i].of_to_string() + '; '
next
ls_ret += ']]]'

lu_nested = this
do while lu_nested.of_has_nested_error()
	lu_nested = lu_nested.of_get_nested_error()
	ls_ret += '; NESTED: ' + lu_nested.of_to_string()
loop

return ls_ret + '}}}'
end function

public function u_exf_error_data of_set_nested_error (throwable ath_throwable);//Zweck		Ein u_exf_error_data-Objekt kann in einem anderen u_exf_error_data-Objekt
//				gespeichert werden (Exception Wrapping).
//				Diese Funktion funktioniert analog der anderen of_set_nested_error()-Varianten, jedoch akzeptiert
//				sie nicht-EXF Exceptions und erstellt für diese ein passendes u_exf_errir_data-Objekt
//Argument	ath_throwable	Exception, RuntimeError oder andere Throwable
//Return		u_exf_error_data	this
//Erstellt	2022-07-05 Simon Reichenbach	Ticket 300366

if not isvalid(ath_throwable) then
	this.of_set_nested_error(gu_e.of_new_error() &
		.of_set_type('throwable') &
		.of_set_message('NULL!') &
	)
else
	this.of_set_nested_error(gu_e.of_new_error() &
		.of_set_type(ath_throwable.classname()) &
		.of_set_message(ath_throwable.getmessage()) &
	)
end if

return this
end function

public function u_exf_error_data of_set_stacktrace ();//Zweck		Ermittelt den aktuellen Stacktrace
//				Falls bereits ein Stacktrace gesetzt wurde, wird er durch den aktuellen Stacktrace ersetzt
//				Normalerweise wird diese Funktion nicht benötigt, weil dies bereits mit gu_e.of_new_error()
//				gemacht wird
//Return		u_exf_error_data	this
//Erstellt	2022-07-19 Simon Reichenbach

long ll_row

ll_row = pf_get_keyval_row(CS_KEY_STACKTRACE)
if ll_row = 0 then
	ll_row = pds_keyval_store.insertrow(0)
end if

pds_keyval_store.setitem(ll_row, 1, CS_KEY_STACKTRACE)
pds_keyval_store.setitem(ll_row, 2, gu_e.of_get_stacktrace())

return this
end function

public function string of_get_stacktrace ();//Zweck		Gibt den in der Exception gespeicherte Stacktrace zurück
//Return		string	Stacktrace im Format 'w_master.of_test(): 1~r~nw_test.dw_detail.+ue_test(): 4~r~n'
//Erstellt	2022-07-18 Simon Reichenbach	Ticket 300424: Stacktrace implementiert

return of_get_value(CS_KEY_STACKTRACE)

end function

public function u_exf_error_data of_set_keyval_store (datastore ads_keyval_store);//Zweck		Ersetzt den kompletten Key-Value-Store des Objekts.
//				Wird für die Deserialisierung des Objekts benötigt und
//				sollte ausserhalb dieses Tasks NICHT verwendet werden.
//Argument	ads_keyval_store	Key-Value-Store
//Return		u_exf_error_data	this
//Erstellt	2022-08-17 Simon Reichenbach

pds_keyval_store = ads_keyval_store

return this
end function

public function blob of_get_value (string as_name, string as_type);//Zweck		Gibt einen bestimmten Value zu einem Namen/Key zurück (Complexe Daten)
//				Falls ein Name mehrfach vorkommt, wird der letzte passende Wert zurückgegeben
//Argument	as_name	Beschreibung/Name des Blobs (u_exf_blob)	
//Return		blob		Value zum Namen, falls Name existiert
//							NULL sonst
//Erstellt	2022-09-12 Simon Reichenbach	Ticket 300424

long ll_i
blob lbl_null
setnull(lbl_null)

for ll_i = upperbound(pu_complex_data) to 1 step -1
	if pu_complex_data[ll_i].is_name = as_name &
	and pu_complex_data[ll_i].is_type = as_type then
		return pu_complex_data[ll_i].ibl_data
	end if
next

return lbl_null
end function

public function string of_get_as_string ();//Deprecated	2022-10-04 Simon Reichenbach	Stattdessen Funktion of_to_string() verwenden
//Zweck			Fehlermeldung als String mit Key/Values
//					Eingebettete Daten (nur bei EXF-Fehlern, ohne Nested Exceptions)
//Return			string
//Erstellt		2022-10-04 Simon Reichenbach	Ticket 300721


return this.of_to_string()

end function

on u_exf_error_data.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_exf_error_data.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//Zweck		Dies ist eine Klasse, welche die Logik und Daten von 
//				u_exf_ex oder u_exf_re beinhaltet
//				Dies wird benötigt, weil u_exf_ex und u_exf_re von unterschiedlichen
//				Klassen erben (müssen) und somit der Code nicht in deren Parent ausgelagert
//				werden kann
//Erstellt 2020-11-16 Simon Reichenbach	Ticket 15230

pds_keyval_store = create datastore

pds_keyval_store.dataobject = 'd_exf_keyval_store'
end event

