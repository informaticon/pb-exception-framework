forward
global type w_exf_error_message from window
end type
type r_gray from rectangle within w_exf_error_message
end type
type st_upload from statictext within w_exf_error_message
end type
type cb_send from commandbutton within w_exf_error_message
end type
type cb_copy from commandbutton within w_exf_error_message
end type
type cb_save from commandbutton within w_exf_error_message
end type
type cb_ok from commandbutton within w_exf_error_message
end type
type cb_more from commandbutton within w_exf_error_message
end type
type st_title from statictext within w_exf_error_message
end type
type ip_icon from inkpicture within w_exf_error_message
end type
type mle_data from multilineedit within w_exf_error_message
end type
type st_box from statictext within w_exf_error_message
end type
type dw_exf_data from datawindow within w_exf_error_message
end type
type st_error from statictext within w_exf_error_message
end type
type tv_data from treeview within w_exf_error_message
end type
end forward

global type w_exf_error_message from window
integer width = 5865
integer height = 2908
boolean titlebar = true
string title = "Programmfehler"
boolean controlmenu = true
windowtype windowtype = response!
string icon = "AppIcon!"
boolean center = true
event ue_expand ( )
event ue_collapse ( )
event ue_set_type ( long al_message_type )
event ue_shortcut ( graphicobject ago_object,  string as_keystroke )
r_gray r_gray
st_upload st_upload
cb_send cb_send
cb_copy cb_copy
cb_save cb_save
cb_ok cb_ok
cb_more cb_more
st_title st_title
ip_icon ip_icon
mle_data mle_data
st_box st_box
dw_exf_data dw_exf_data
st_error st_error
tv_data tv_data
end type
global w_exf_error_message w_exf_error_message

type variables

protected boolean pbo_expanded
protected long pl_message_type

constant long CL_MESSAGE_TYPE_DATABASE = 1 //u_exf_re_database
constant long CL_MESSAGE_TYPE_ERROR = 2 //u_exf_ex/u_exf_re
constant long CL_MESSAGE_TYPE_FATAL = 3 //RuntimeError
constant long CL_MESSAGE_TYPE_SYSERROR = 4 //u_exf_re_systemerror

protected string ps_exf_server_access_code
end variables

forward prototypes
protected subroutine pf_add_error (u_exf_error_data au_error, long al_level)
protected subroutine pf_show (any aa_data)
protected function boolean pf_is_inherited_from (ref powerobject apo_object, string as_parent_classname)
protected function string pf_tos (any aa_value)
protected function string pf_get_clipboard_text ()
protected subroutine pf_upload ()
end prototypes

event ue_expand();long ll_item
treeviewitem ltvi_item
pbo_expanded = true
this.width = 5500
this.height = 2800

tv_data.show()
r_gray.hide()
st_box.show()
st_upload.event ue_set_bg_white()

//2021-02-03 Simon Reichenbach, Ticket 19895: Verbesserung Usability EXF, standardmässig aktuell ausgewähltes Element anzeigen
tv_data.setfocus()
ll_item = tv_data.finditem(currenttreeitem!, 0)
if ll_item > 0 then
	if tv_data.getitem(ll_item, ltvi_item) > 0 then
		pf_show(ltvi_item.data)
	end if
end if
end event

event ue_collapse();
pbo_expanded = false
this.width = 2140

if pos(st_upload.text, '~n') > 0 then
	this.height = 1100
else
	this.height = 1050
end if

tv_data.hide()
dw_exf_data.hide()
mle_data.hide()
st_box.hide()
r_gray.show()
st_upload.event ue_set_bg_grey()

//2021-02-03 Simon Reichenbach, Ticket 19895: Verbesserung Usability EXF
cb_ok.setfocus()
end event

event ue_set_type(long al_message_type);//Zweck		Blendet Menüpunkte ein und aus und setzt allgemein den Stil der Meldung,
//				je nachdem was für ein Typ von Meldung angezeigt wird
//Argument	al_message_type	Nachrichtentyp (CL_MESSAGE_TYPE_*)
//Erstellt	2020-11-17 Simon Reichenbach

choose case al_message_type
	case CL_MESSAGE_TYPE_DATABASE
		this.title = gu_e.of_get_app_adapter().of_get_text(17064, ' Database error')
		st_title.text = gu_e.of_get_app_adapter().of_get_text(131000001, 'A database error occured')
		ip_icon.loadpicture(gu_e.of_get_app_adapter().of_get_image(gu_e.of_get_app_adapter().CL_IMAGE_WARNING))
		cb_more.enabled = true
		cb_save.enabled = true
		
	case CL_MESSAGE_TYPE_ERROR
		this.title = gu_e.of_get_app_adapter().of_get_text(17063, 'Error')
		st_title.text = gu_e.of_get_app_adapter().of_get_text(16980, 'An error occured')
		ip_icon.loadpicture(gu_e.of_get_app_adapter().of_get_image(gu_e.of_get_app_adapter().CL_IMAGE_WARNING))
		cb_more.enabled = true
		cb_save.enabled = true

	case CL_MESSAGE_TYPE_SYSERROR
		this.title = gu_e.of_get_app_adapter().of_get_text(17063, 'Error')
		st_title.text = gu_e.of_get_app_adapter().of_get_text(16981, 'A serious error occured')
		ip_icon.loadpicture(gu_e.of_get_app_adapter().of_get_image(gu_e.of_get_app_adapter().CL_IMAGE_ERROR))
		cb_more.enabled = true
		cb_save.enabled = true
		
	case else
		this.title = gu_e.of_get_app_adapter().of_get_text(17063, 'Error')
		st_title.text = gu_e.of_get_app_adapter().of_get_text(16981, 'A serious error occured')
		ip_icon.loadpicture(gu_e.of_get_app_adapter().of_get_image(gu_e.of_get_app_adapter().CL_IMAGE_ERROR))
		cb_more.enabled = false
		cb_save.enabled = false
	
end choose

end event

event ue_shortcut(graphicobject ago_object, string as_keystroke);//Zweck		Führt die Aktion aus, welche mit einem bestimmten Shortcut gebunden ist
//Argument	ago_object		Objekt, welches aktuell den Fokus hat
//				as_keystroke	Tastenkombination ('Ctrl+S', 'Ctrl+C', 'Ctrl+A', ...)
//Erstellt	2021-02-09 Simon Reichenbach, Ticket 19895: Verbesserung Usability EXF


choose case as_keystroke
	case 'Ctrl+A' //Alles auswählen
		if pbo_expanded and mle_data = ago_object then
			mle_data.selecttext(1, len(mle_data.text))
		end if
		
	case 'Ctrl+C' //In Zwischenablage kopieren
		if pbo_expanded and ago_object = mle_data then
			//User hat evtl. einen speziellen String ausgewählt, deshalb nur Auswahl kopieren
			mle_data.copy()
		elseif pbo_expanded then
			//User ist zurzeit auf einem anderen Control, deshalb alles kopieren
			::clipboard(mle_data.text)
		else //pbo_expanded = false
			cb_copy.event clicked()
		end if
	
	case 'Ctrl+S' //Speichern
		cb_save.event clicked()
		
end choose
end event

protected subroutine pf_add_error (u_exf_error_data au_error, long al_level);//Zweck		Fügt einen Fehler in die TreeView ein
//				Ruft sich für eingebettete Fehler (nested error) rekursiv auf
//Argument	au_error	u_exf_error_data-Instanz, die eingefügt werden soll
//				al_level	Hierarchiestufe, in welcher der Fehler eingefügt werden soll (root=0)
//Erstellt	2020-11-17 Simon Reichenbach
//Geändert	2020-12-08 Simon Reichenbach Key-Value nicht nur als blob

treeviewitem tvi_i
long ll_item_root
long ll_item_keyvalcontainer
long ll_i
datastore lds_keyval
constant long LCL_PICTURE_EXCEPTION = 1
constant long LCL_PICTURE_VALUE = 2
constant long LCL_PICTURE_BLOB = 3

u_exf_blob lu_blob[]

//Haupteintrag
tvi_i.label = pf_tos(au_error.of_get_type())
tvi_i.data = au_error
tvi_i.children = true
tvi_i.pictureindex = LCL_PICTURE_EXCEPTION
tvi_i.selectedpictureindex = LCL_PICTURE_EXCEPTION
ll_item_root = tv_data.insertitemfirst(al_level, tvi_i)

//Variablen
lu_blob = au_error.of_get_dump()
for ll_i = 1 to upperbound(lu_blob)
	tvi_i.label = pf_tos(lu_blob[ll_i].is_name) + ' (' + pf_tos(lu_blob[ll_i].is_type) + ')'
	tvi_i.data = lu_blob[ll_i]

	//2021-02-03 Simon Reichenbach, Ticket 19895: Verbesserung Usability EXF
	if lu_blob[ll_i].is_name = 'key-value-store' then
		tvi_i.pictureindex = LCL_PICTURE_VALUE
		tvi_i.selectedpictureindex = LCL_PICTURE_VALUE
		tvi_i.children = true
		ll_item_keyvalcontainer = tv_data.insertitemfirst(ll_item_root, tvi_i)
		
		if al_level = 0 then
			tv_data.selectitem(ll_item_keyvalcontainer)
		end if
	else
		tvi_i.pictureindex = LCL_PICTURE_BLOB
		tvi_i.selectedpictureindex = LCL_PICTURE_BLOB
		tvi_i.children = false
		tv_data.insertitemlast(ll_item_root, tvi_i)
	end if
next

//key-val-store
//2022-03-30 Simon Reichenbach, Ticket 21348: Bessere Usability implementiert
lds_keyval = au_error.of_get_keyval_store()
for ll_i = 1 to lds_keyval.rowcount()
	tvi_i.label = pf_tos(lds_keyval.getitemstring(ll_i, 'key'))
	tvi_i.data = pf_tos(lds_keyval.getitemstring(ll_i, 'value'))
	tvi_i.children = false
	tvi_i.pictureindex = LCL_PICTURE_VALUE
	tvi_i.selectedpictureindex = LCL_PICTURE_VALUE
	tv_data.insertitemlast(ll_item_keyvalcontainer, tvi_i)
next

//Nested Exceptions
if au_error.of_has_nested_error() then
	pf_add_error(au_error.of_get_nested_error(), ll_item_root)
end if

end subroutine

protected subroutine pf_show (any aa_data);//Zweck		Zeigt einen Eintrag (Variable, Nested Error) eines Fehlers an
//				Wird aufgerufen, wenn der User in der TreeView einen Eintrag anklickt
//Argument	aa_data	Daten, welche im TreeView-Item gespeichert waren
//Erstellt	2020-11-17 Simon Reichenbach

u_exf_blob lu_blob
u_exf_error_data lu_error_dummy
lu_error_dummy = create u_exf_error_data //wird ledigilich für den Zugriff auf Konstanten von u_exf_error_data benötigt

mle_data.hide()
dw_exf_data.hide()

if isnull(aa_data) then return

if classname(aa_data) = 'u_exf_blob' then
	lu_blob = aa_data
	if lu_blob.ibo_confidential then
		mle_data.text = 'This data is confidential and therefore cannot be displayed'
		mle_data.show()
		return
	end if
	
	if lu_blob.is_type = lu_error_dummy.CS_COMPLEX_DATA_DATAOBJECT then
		dw_exf_data.setfullstate(lu_blob.ibl_data)
		dw_exf_data.show()
	else
		mle_data.text = string(lu_blob.ibl_data, encodingutf8!)
		mle_data.show()
	end if
else
	mle_data.text = pf_tos(aa_data)
	mle_data.show()
end if

end subroutine

protected function boolean pf_is_inherited_from (ref powerobject apo_object, string as_parent_classname);//Zweck		Prüft ein Objekt ob es von einem bestimmten Parentobjekt vererbt wurde
//				Das Objekt muss nicht direkt vom Parentobjekt vererbt sein, es können auch eine Anzahl Vererbungstufen dazwischen liegen
//				Beispiele: 
//				Objekt = dis2_w_exf_dis_start, Parent-Objekt = dis1_w_exf_dis_start -> Return = true
//				Objekt = dis2_w_exf_dis_start, Parent-Objekt = w_exf_master -> Return = true
//Arg			ref apo_object	Zu prüfendes Object
//				as_parent_classname
//Return		true	apo_object ist ein Nachkomme von as_parent_classname
//				false	apo_object ist kein Nachkomme von as_parent_classname
//Erstellt	2017-11-28 Martin Abplanalp
//Geändert	2020-11-17 Simon Reichenbach Con exf1_u_exf_service importiert

classdefinition lcd_temp

lcd_temp = apo_object.classdefinition
as_parent_classname = lower(as_parent_classname)

do while isvalid(lcd_temp)
	if lower(lcd_temp.name) = as_parent_classname then return true
	lcd_temp = lcd_temp.ancestor
loop

return false

end function

protected function string pf_tos (any aa_value);//Zweck		Konvertiert einen Wert in einen String
//				Stellt ausserdem sicher, dass kein NULL-String zurückgegeben wird
//Argument	aa_value
//Return		string	aa_value als String, aber niemals NULL
//Erstellt	2020-11-17 Simon Reichenbach

if isnull(aa_value) then
	return 'NULL (' + classname(aa_value) + ')'
end if

choose case classname(aa_value)
	case 'string'
		return aa_value
		
	case 'int', 'integer', 'unsignedinteger', 'unsignedint', 'uint', 'decimal', 'dec', 'double', &
			'long', 'longlong', 'byte', 'unsignedlong', 'ulong', 'char', 'date', 'datetime', 'time'
		return string(aa_value)
		
	case else
		return '(' + classname(aa_value) + ')'
		
end choose



 
 
end function

protected function string pf_get_clipboard_text ();//Zweck		Gibt die Fehlermeldung als String für die Zwischenabnlage zurück
//Return		string
//Erstellt	2021-02-02 Simon Reichenbach Ticket 19895

long ll_i
string ls_ret
u_exf_blob lu_err[]
datastore lds_data

//Hauptmeldung, sollte immer existieren
ls_ret = pf_tos(st_error.text)
if isnull(tv_data.event ue_get_error()) then
	return ls_ret
end if

//Exception ID und Schlüssel kopieren
ls_ret += '~r~n----------------------------------------~r~n'
ls_ret += 'Exception ID: ' + pf_tos(st_upload.text)

//Eingebettete Daten (nur bei EXF-Fehlern, ohne Nested Exceptions)
//blobs werden nicht kopiert
lds_data = tv_data.event ue_get_error().of_get_keyval_store()
for ll_i = 1 to lds_data.rowcount()
	ls_ret += '~r~n----------------------------------------~r~n'
	ls_ret += pf_tos(lds_data.getitemstring(ll_i, 1)) + '~r~n'
	ls_ret += pf_tos(lds_data.getitemstring(ll_i, 2))
next

return ls_ret
end function

protected subroutine pf_upload ();//Zweck		Lädt die Exception auf den Exception Server hoch
//				Wird beim Öffnen des Fensters per post aufgerufen
//				Dies feature ist nur für Exception mit Error-Objekt (EXF-Exceptions) möglich
//				Name und Verschlüsselungs-Schüssel werden im GUI angezeigt
//Erstellt	2022-08-17 Simon Reichenbach

string ls_key
string ls_filename
u_exf_error_data lu_error

try
	lu_error = tv_data.event ue_get_error()
	if isnull(lu_error) then
		st_upload.text = ''
		return
	end if
	randomize(0)
	ls_filename = string(today(), 'YYYYmmdd') + '_' + string(now(), 'hhmmss') + '_' + string(rand(32767))
	ls_key = gu_e.of_get_app_adapter().of_upload(lu_error, ls_filename)
	ps_exf_server_access_code = ls_filename + ' / ' + ls_key
	
	st_upload.text = gu_e.of_get_app_adapter().of_get_text(18686, 'Analysis information was transmitted to Informaticon.~r~nAccess code: ') + &
		+ ps_exf_server_access_code
	this.event ue_collapse()
	
catch (throwable lth)
	st_upload.text = 'Error: ' + pf_tos(lth.getmessage())
end try

end subroutine

on w_exf_error_message.create
this.r_gray=create r_gray
this.st_upload=create st_upload
this.cb_send=create cb_send
this.cb_copy=create cb_copy
this.cb_save=create cb_save
this.cb_ok=create cb_ok
this.cb_more=create cb_more
this.st_title=create st_title
this.ip_icon=create ip_icon
this.mle_data=create mle_data
this.st_box=create st_box
this.dw_exf_data=create dw_exf_data
this.st_error=create st_error
this.tv_data=create tv_data
this.Control[]={this.r_gray,&
this.st_upload,&
this.cb_send,&
this.cb_copy,&
this.cb_save,&
this.cb_ok,&
this.cb_more,&
this.st_title,&
this.ip_icon,&
this.mle_data,&
this.st_box,&
this.dw_exf_data,&
this.st_error,&
this.tv_data}
end on

on w_exf_error_message.destroy
destroy(this.r_gray)
destroy(this.st_upload)
destroy(this.cb_send)
destroy(this.cb_copy)
destroy(this.cb_save)
destroy(this.cb_ok)
destroy(this.cb_more)
destroy(this.st_title)
destroy(this.ip_icon)
destroy(this.mle_data)
destroy(this.st_box)
destroy(this.dw_exf_data)
destroy(this.st_error)
destroy(this.tv_data)
end on

event open;long ll_first_item
powerobject lu_parm
u_exf_error_data lu_error

lu_parm = message.powerobjectparm

//Argument auspacken
if pf_is_inherited_from(lu_parm, 'u_exf_ex') &
or pf_is_inherited_from(lu_parm, 'u_exf_re') then
	//Exception/RuntimeError vom Exception Framework
	lu_error = lu_parm.dynamic of_get_error()
elseif pf_is_inherited_from(lu_parm, 'u_exf_error_data') then
	//Error-Daten vom Exception Framework
	lu_error = lu_parm
end if

//Fehlermeldungstyp ermitteln
if isvalid(lu_error) then
	choose case lu_error.of_get_type()
		case 'u_exf_re_database'
			pl_message_type = CL_MESSAGE_TYPE_DATABASE
		case 'u_exf_re_systemerror'
			pl_message_type = CL_MESSAGE_TYPE_SYSERROR
		case else
			pl_message_type = CL_MESSAGE_TYPE_ERROR
	end choose
	pf_add_error(lu_error, 0)
else
	pl_message_type = CL_MESSAGE_TYPE_FATAL
end if

//Fehlermeldung anzeigen, es werden auch Exceptions/RuntimeErrors unterstützt,
//die nicht vom Exception Framework stammen
if isvalid(lu_error) then
	st_error.text = gu_e.of_get_app_adapter().of_get_text( &
						lu_error.of_get_message_tbz(), &
						lu_error.of_get_message() &
					)
else //Andere throwable
	st_error.text = lu_parm.dynamic getmessage()
end if

//Auf erstes Element scrollen und dieses aufklappen
ll_first_item = tv_data.finditem(roottreeitem!, 0)
tv_data.expanditem(ll_first_item)
tv_data.setfirstvisible(ll_first_item)

this.event ue_set_type(pl_message_type)
this.event ue_collapse()

gu_e.of_get_app_adapter().of_spawn_window(this)

if gu_e.of_get_app_adapter().of_is_auto_ubload_enabled() then
	st_upload.text = 'Uploading...'
	this.post pf_upload()
else
	st_upload.text = gu_e.of_get_app_adapter().of_get_text(18687, 'Automatic transmission of analysis information to Informaticon is disabled.')
end if
end event

event resize;tv_data.height = newheight - tv_data.y - 20
dw_exf_data.height = newheight - dw_exf_data.y - 20
dw_exf_data.width = newwidth - dw_exf_data.x - 30
mle_data.height = newheight - mle_data.y - 24
mle_data.width = newwidth - mle_data.x - 38
st_box.width = newwidth - st_box.x - 30
st_box.height = newheight - st_box.y - 20
end event

event close;
gu_e.of_get_app_adapter().of_unspawn_window(this)

end event

event key;if keydown(keycontrol!) then
	choose case key
		case keyc!
			this.event ue_shortcut(getfocus(), 'Ctrl+C')
			
		case keya!
			this.event ue_shortcut(getfocus(), 'Ctrl+A')
			
	end choose
end if

return 0
end event

type r_gray from rectangle within w_exf_error_message
long linecolor = 33554432
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 67108864
integer y = 672
integer width = 2231
integer height = 352
end type

type st_upload from statictext within w_exf_error_message
event ue_set_bg_grey ( )
event ue_set_bg_white ( )
integer x = 37
integer y = 832
integer width = 1975
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217745
long backcolor = 67108864
string text = "Automatic transmission of analysis information to Informaticon is disabled."
alignment alignment = right!
boolean focusrectangle = false
end type

event ue_set_bg_grey();this.backcolor = r_gray.fillcolor
end event

event ue_set_bg_white;this.backcolor = parent.backcolor
end event

event clicked;::clipboard(ps_exf_server_access_code)
end event

type cb_send from commandbutton within w_exf_error_message
integer x = 1714
integer y = 708
integer width = 320
integer height = 112
integer taborder = 60
integer textsize = -17
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "📧"
end type

event clicked;
gu_e.of_get_app_adapter().of_report_case(pf_get_clipboard_text())
end event

type cb_copy from commandbutton within w_exf_error_message
integer x = 1344
integer y = 708
integer width = 320
integer height = 112
integer taborder = 70
integer textsize = -15
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "📋"
end type

event clicked;::clipboard(pf_get_clipboard_text())
end event

type cb_save from commandbutton within w_exf_error_message
integer x = 974
integer y = 708
integer width = 320
integer height = 112
integer taborder = 40
integer textsize = -20
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "🖫"
end type

event clicked;gu_e.of_save_to_file(tv_data.event ue_get_error())

end event

type cb_ok from commandbutton within w_exf_error_message
integer x = 37
integer y = 708
integer width = 494
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean cancel = true
boolean default = true
end type

event clicked;close(parent)
end event

type cb_more from commandbutton within w_exf_error_message
integer x = 603
integer y = 708
integer width = 320
integer height = 112
integer taborder = 30
integer textsize = -15
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "🔍"
end type

event clicked;if pbo_expanded then
	parent.event ue_collapse()
else
	parent.event ue_expand()
end if
end event

type st_title from statictext within w_exf_error_message
integer x = 320
integer y = 80
integer width = 1371
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean focusrectangle = false
end type

type ip_icon from inkpicture within w_exf_error_message
integer x = 82
integer y = 48
integer width = 160
integer height = 140
boolean border = false
boolean enabled = false
end type

event constructor;
this.inkenabled = false
this.picturesizemode = inkpicstretched!
end event

type mle_data from multilineedit within w_exf_error_message
boolean visible = false
integer x = 2126
integer y = 204
integer width = 3675
integer height = 2592
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean border = false
boolean hscrollbar = true
boolean vscrollbar = true
boolean displayonly = true
end type

type st_box from statictext within w_exf_error_message
integer x = 2094
integer y = 176
integer width = 3712
integer height = 2624
integer textsize = -15
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean border = true
boolean focusrectangle = false
end type

type dw_exf_data from datawindow within w_exf_error_message
boolean visible = false
integer x = 2094
integer y = 176
integer width = 3712
integer height = 2624
integer taborder = 90
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type st_error from statictext within w_exf_error_message
integer x = 59
integer y = 244
integer width = 1998
integer height = 412
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean focusrectangle = false
end type

type tv_data from treeview within w_exf_error_message
event type u_exf_error_data ue_get_error ( )
boolean visible = false
integer x = 37
integer y = 960
integer width = 2011
integer height = 1824
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string picturename[] = {"UserObject_icon_2!","DataWindow5!","Structure_icon_2!","","","","","",""}
long picturemaskcolor = 16777215
long statepicturemaskcolor = 536870912
end type

event type u_exf_error_data ue_get_error();//Zweck		Gibt u_exf_error_data-Objekt zurück welches in der TreeView gespeichert ist
//Return		u_exf_error_data	Hauptobjekt
//				null					Falls Objekt nicht existiert
//Erstellt	2020-11-17 Simon Reichenbach

u_exf_error_data lu_error
treeviewitem tvi_i

//Das Objekt befindet sich im Hauptknoten
if tv_data.getitem(1, tvi_i) = 1 then
	lu_error = tvi_i.data
else
	setnull(lu_error)
end if

return lu_error
end event

event selectionchanged;treeviewitem tvi_i

if this.getitem(newhandle, tvi_i) = 1 then
	pf_show(tvi_i.data)
end if

end event

