$PBExportHeader$u_exf_error_manager.sru
forward
global type u_exf_error_manager from nonvisualobject
end type
type st_encrypt_result from structure within u_exf_error_manager
end type
type iu_as from u_exf_error_creator within u_exf_error_manager
end type
end forward

type st_encrypt_result from structure
	string		s_key
	blob		bl_cipher
end type

global type u_exf_error_manager from nonvisualobject
iu_as iu_as
end type
global u_exf_error_manager u_exf_error_manager

type prototypes


protected function boolean pef_get_stacktrace( &
	ref string as_call_stack[] &
) system library 'exf1.dll' alias for 'get_stacktrace'
end prototypes

type variables


//In dieser Variable wird der zuletzt erstellte Error gespeichert
//Dies wird im systemerror-Event benötigt für den Fall, dass jemand
// eine Funktion/Event mittels dynamic aufruft und dort eine Exception geworfen wurde.
//	=> Andernfalls würden die Informationen verloren gehen
protected u_exf_error_data pu_last_error

//Der Adapter wird für dependency injection benötigt, damit kann das EXF
//z.B. Sprachtexte holen, das A3 blurren (Milchglasfilter) und Fensterpositionen ermitteln
protected u_exf_application_adapter pu_app_adapter

end variables

forward prototypes
public subroutine of_display (u_exf_error_data au_error)
public subroutine of_save_to_folder (u_exf_error_data au_error, string as_folder)
public function u_exf_error_data of_new_error ()
protected function string pf_clean_string (string as_string)
public subroutine of_save_to_folder (u_exf_error_data au_error)
public function u_exf_error_data of_get_last_error ()
public subroutine of_set_app_adapter (u_exf_application_adapter au_app_adapter)
public subroutine of_display (throwable ath_error)
public function u_exf_application_adapter of_get_app_adapter ()
public function string of_get_stacktrace ()
public function long of_get_stacktrace (ref string as_stacktrace[])
public subroutine of_save_to_file (u_exf_error_data au_error, string as_filepath)
public subroutine of_save_to_file (u_exf_error_data au_error)
end prototypes

public subroutine of_display (u_exf_error_data au_error);//Zweck		Zeigt dem Benutzer eine u_exf_error_data-Instanz als Fehlermeldung an
//Argument	au_error u_exf_error_data-Instanz
//Erstellt	2020-11-16 Simon Reichenbach

pu_app_adapter.of_display(au_error)
end subroutine

public subroutine of_save_to_folder (u_exf_error_data au_error, string as_folder);//Zweck		Exportiert alle Daten eines u_exf_error_data-Objekts in einen bestimmten Pfad
//Argument	au_error		u_exf_error_data-Instanz
//				as_folder	Absoluter Dateipfad (Ordner), in welchem die Daten abgelegt werden sollen
//Erstellt	2020-11-16 Simon Reichenbach

long ll_i
string ls_file_name
integer li_file
u_exf_blob lu_blob[]

//Argumentprüfung
if isnull(as_folder) then
	throw(this.iu_as.of_re_illegalargument(this.of_new_error() &
		.of_set_nested_error(au_error) &
		.of_push(populateerror(0, 'as_folder ist NULL'))))
end if

//Dateipfad erstellen, falls nötig
if not directoryexists(as_folder) then
	if not createdirectory(as_folder) = 1 then
		throw(this.iu_as.of_re_io(this.of_new_error()&
				.of_set_nested_error(au_error) &
				.of_push('as_folder', as_folder) &
				.of_push(populateerror(0, 'Ordner konnte nicht erstellt werden'))))
	end if
end if

if right(as_folder, 1) <> '\' then as_folder += '\'

//Pro u_exf_blob-Instanz soll eine Datei geschrieben werden
lu_blob = au_error.of_get_dump()
for ll_i = 1 to upperbound(lu_blob)
	//2021-02-11 Simon Reichenbach, Ticket 19895: Abhängigkeit in GS entfernt
	ls_file_name = string(ll_i) &
		+ '_' + pf_clean_string(lu_blob[ll_i].is_type) &
		+ '_' + pf_clean_string(lu_blob[ll_i].is_name)
		
		li_file = fileopen(as_folder + ls_file_name, streammode!, write!, shared!, replace!)
		if li_file > 0 then
			filewriteex(li_file, lu_blob[ll_i].ibl_data)
			fileclose(li_file)
		else
			throw(this.iu_as.of_re_io(this.of_new_error()&
					.of_set_nested_error(au_error) &
					.of_push('as_folder', as_folder) &
					.of_push('ls_file_name', ls_file_name) &
					.of_push(populateerror(0, 'Datei konnte nicht zum Schreiben geöffnet werden'))))
		end if
next

//Nested-Exception soll ebenfalls exportiert werden (Rekursion)
if au_error.of_has_nested_error() then
	of_save_to_folder(au_error.of_get_nested_error(), &
						as_folder + au_error.of_get_nested_error().of_get_type())
end if


end subroutine

public function u_exf_error_data of_new_error ();//Zweck		Instanziert ein neues u_exf_error_data-Objekt
//Return		u_exf_error_data	
//Erstellt	2020-11-16 Simon Reichenbach
//Geändert	2022-07-19 Simon Reichenbach, Ticket 300424: Stacktrace implementiert

u_exf_error_data lu_error
lu_error = create u_exf_error_data

lu_error.of_set_stacktrace()

return lu_error
end function

protected function string pf_clean_string (string as_string);//Zweck		Entfernt unsichere Zeichen aus einem String
//				Wird benötigt, um Sicherzustellen, dass ein Dateiname keine ungültigen Zeichen enthält
//Argument	as_string	String, aus welchem unsichere Zeichen entfernt werden sollen
//Return		string		as_string, welches nur noch folgende Zeichen enthält: A-Z, a-z, 0-9, -, _
//								'null', falls as_string null ist
//Erstellt	2020-11-16 Simon Reichenbach
//Geändert	2021-02-11 Simon Reichenbach, Ticket 19895: Abhängigkeit in Grundsicht entfernt

long ll_i
long ll_len
string ls_ret = ''
integer li_i

ll_len = len(as_string)
for ll_i = 1 to ll_len
	li_i = asca(mid(as_string, ll_i, 1))
	
	if li_i >= 48 and li_i <= 57 /* 0-9 */ &
	or li_i >= 65 and li_i <= 90 /* A-Z */ &
	or li_i >= 97 and li_i <= 122 /* a-z */ &
	or ll_i = 95 or li_i = 45 /* _- */ then
		ls_ret = ls_ret + chara(li_i)
	else
		ls_ret = ls_ret + '_'
	end if
	
next
if isnull(ls_ret) then
	return 'null'
else
	return ls_ret
end if
end function

public subroutine of_save_to_folder (u_exf_error_data au_error);//Zweck		Wrapper-Funktion für of_save_to_folder(au_error, as_path)
//				Fragt den Benutzer nach einem Speicherpfad und speichert au_error in diesen Pfad
//Argument	au_error u_exf_error_data-Objekt, welches exportiert werden soll
//Erstellt	2020-07-09 Simon Reichenbach
//Geändert	2023-01-24 Simon Reichenbach, Ticket 306720

string ls_folder
string ls_currentdir

ls_currentdir = getcurrentdirectory()
try
	//2021-02-09 Simon Reichenbach, Ticket 19895: Verbesserung Usability EXF, Unterordner für Exception erstellen
	if getfolder('Fehlerprotokoll Speichern', ls_folder) = 1 then
		if right(ls_folder, 1) <> '\' then ls_folder += '\'
		of_save_to_folder(au_error, ls_folder + '\' + string(today(), 'error_yyyy-MM-dd_hh-mm-ss'))
	end if
finally
	changedirectory(ls_currentdir)
end try

end subroutine

public function u_exf_error_data of_get_last_error ();//Zweck		Gibt den letzten verwendeten Error zurück
//				Dies wird im systemerror-Event benötigt für den Fall, dass jemand
//				eine Funktion/Event mittels dynamic aufruft und dort eine Exception geworfen wurde.
//				=> Andernfalls würden die Informationen verloren gehen
//Return		u_exf_error_data	
//Erstellt	2020-11-17 Simon Reichenbach

return pu_last_error
end function

public subroutine of_set_app_adapter (u_exf_application_adapter au_app_adapter);//Zweck		Setter für den Applikationsadapter
//				Der Appliationsadapter wird benötigt, damit das Exceptionframework 
//Argument	au_adapter	
//Return		string	
//Erstellt	2020-11-17 Simon Reichenbach

pu_app_adapter = au_app_adapter




end subroutine

public subroutine of_display (throwable ath_error);//Zweck		Zeigt dem Benutzer einen RuntimeError oder Exception als Fehlermeldung an
//Argument	ath_e	u_exf_re-Objekt
//						u_exf_ex-Objekt
//						beliebiges anderes throwable-Objekt
//Erstellt	2020-11-16 Simon Reichenbach

pu_app_adapter.of_display(ath_error)

end subroutine

public function u_exf_application_adapter of_get_app_adapter ();//Zweck		Getter für den App-Adapter
//				Der App-Adapter wird benötigt, um vom Exception Framework auf Funktionen der Applikation (A3)
//				zuzugreifen, ohne dabei von dieser Abhängig zu sein (Dependency Injection)
//Return		u_exf_application_adapter-Instanz (falls keine definiert wurde, wird ein Dummy-Adapter erstellt und zurückgegeben)
//Erstellt	2020-11-17 Simon Reichenbach

return pu_app_adapter

end function

public function string of_get_stacktrace ();//Zweck		Gibt den aktuellen Stacktrace zurück
//Return		Beispiel: 'inf1_u_application.of_test(): 3~r~ninf1_w_test.de_detail.+ue_test(): 3~r~n'
//				Im Fehlerfall wird ein Leerstring zurückgegeben
//Erstellt	2022-07-18 Simon Reichenbach	Ticket 300424: Stacktrace implementiert

string ls_stacktrace[]
string ls_ret
long ll_i
try
	if of_get_stacktrace(ls_stacktrace) = 0 then
		return ''
	end if
	
	//Letztes Element ist of_get_stacktrace(), das interessiert nicht und wird deshalb abgeschnitten
	for ll_i = 1 to upperbound(ls_stacktrace) - 1
		ls_ret += ls_stacktrace[ll_i] + '~r~n'
	next
	
	return ls_ret
		
catch(throwable ath_e)
	return ''
end try
end function

public function long of_get_stacktrace (ref string as_stacktrace[]);//Zweck		Gibt den aktuellen Stacktrace zurück
//Argument	ref as_stacktrace[]	Array mit Stacktrace (pro Funktion eine Zeile)
//Return		n	Anzahl Elemente in as_stacktrace
//				0	Falls ein Fehler auftritt
//Erstellt	2022-07-19 Simon Reichenbach	Ticket 300424: Stacktrace implementiert

string ls_ret[]
long ll_i

//as_stacktrace leeren
as_stacktrace = ls_ret

try
	pef_get_stacktrace(ls_ret)
	
	//Letztes Element ist of_get_stacktrace(), das interessiert nicht und wird deshalb abgeschnitten
	for ll_i = 1 to upperbound(ls_ret) - 1
		as_stacktrace[ll_i] = ls_ret[ll_i]
	next
	
	return upperbound(as_stacktrace[])

catch(throwable ath_e)
	return 0
end try
end function

public subroutine of_save_to_file (u_exf_error_data au_error, string as_filepath);//Zweck		Exportiert alle Daten eines u_exf_error_data-Objekts in einen bestimmten Pfad
//				JSON Objekt mit der Dateiendung .exf
//Argument	au_error		u_exf_error_data-Instanz
//				as_filepath	Absoluter Dateipfad (Datei), in welcher die Daten abgelegt werden sollen
//Erstellt	2023-01-24 Simon Reichenbach, Ticket 300424: EXF Analyzer

u_exf_serialization lu_serialization
blob lbl_data
integer li_file
lu_serialization = create u_exf_serialization

if not isvalid(au_error) then
	throw(this.iu_as.of_re_illegalargument(this.of_new_error() &
		.of_push(populateerror(0, 'au_error is NULL')) &
	))
end if

lbl_data = lu_serialization.of_serialize(au_error)

li_file = fileopen(as_filepath,  streammode!, write!, lockreadwrite!, replace!)
if li_file < 1 then
	throw(this.iu_as.of_re_illegalargument(this.of_new_error() &
		.of_push(populateerror(0, 'Could not open file')) &
		.of_push('as_filepath', as_filepath) &
		.of_push('li_file', li_file) &
	))
end if

try
	if filewriteex(li_file, lbl_data) < 0 then
		throw(this.iu_as.of_re_illegalargument(this.of_new_error() &
			.of_push(populateerror(0, 'Could not write file')) &
			.of_push('as_filepath', as_filepath) &
		))
	end if
finally
	fileclose(li_file)
end try	
end subroutine

public subroutine of_save_to_file (u_exf_error_data au_error);//Zweck		Wrapper-Funktion für of_save_to_file(au_error, as_filepath)
//				Fragt den Benutzer nach einem Speicherpfad und speichert au_error in diesen Pfad
//Argument	au_error		u_exf_error_data-Instanz
//Erstellt	2023-01-24 Simon Reichenbach, Ticket 300424: EXF Analyzer

string ls_file
string ls_filepath
string ls_currentdir
ls_currentdir = getcurrentdirectory()
try
	if getfilesavename('Save exception', ls_filepath, ls_file, 'exf', 'Exception File (*.exf),*.exf') <> 1 then
		return
	end if
	
	of_save_to_file(au_error, ls_filepath)
finally
	changedirectory(ls_currentdir)
end try

end subroutine

on u_exf_error_manager.create
call super::create
this.iu_as=create iu_as
TriggerEvent( this, "constructor" )
end on

on u_exf_error_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
destroy(this.iu_as)
end on

event constructor; //Fallback-Adapter, falls nach dem Instanzieren kein eigener Adapter definiert wird
 pu_app_adapter = create u_exf_application_adapter
 
end event

type iu_as from u_exf_error_creator within u_exf_error_manager descriptor "pb_nvo" = "true" 
end type

on iu_as.create
call super::create
end on

on iu_as.destroy
call super::destroy
end on

event ue_register_error;call super::ue_register_error;//Zweck		Wird immer dann aufgerufen,
//				wenn ein Error-Objekt in eine Exception/RuntimeError verpackt wird
//				Der Event speichert das letzte verwendete Error-Objekt, damit
//				dieses im systemerror-Event zur Verfügung steht
//Argument	au_error	
//Erstellt	2020-11-17 Simon Reichenbach

pu_last_error = au_error
end event

