forward
global type w_exf_analyzer from window
end type
type cb_fire_update_statement from commandbutton within w_exf_analyzer
end type
type cb_show_sql_select from commandbutton within w_exf_analyzer
end type
type cb_show_dw_syntax from commandbutton within w_exf_analyzer
end type
type cb_show_data from commandbutton within w_exf_analyzer
end type
type cb_save_disk from commandbutton within w_exf_analyzer
end type
type cb_export_disk from commandbutton within w_exf_analyzer
end type
type cb_db_connect_manual from commandbutton within w_exf_analyzer
end type
type cb_db_connect_odbc from commandbutton within w_exf_analyzer
end type
type cb_load_disk from commandbutton within w_exf_analyzer
end type
type dw_log from u_exf_log within w_exf_analyzer
end type
type st_key from statictext within w_exf_analyzer
end type
type st_id from statictext within w_exf_analyzer
end type
type cb_paste from commandbutton within w_exf_analyzer
end type
type cb_load_server from commandbutton within w_exf_analyzer
end type
type sle_key from singlelineedit within w_exf_analyzer
end type
type sle_file from singlelineedit within w_exf_analyzer
end type
type r_data from rectangle within w_exf_analyzer
end type
type cb_show_update_statement from commandbutton within w_exf_analyzer
end type
type gb_server from groupbox within w_exf_analyzer
end type
type gb_local from groupbox within w_exf_analyzer
end type
type gb_connection from groupbox within w_exf_analyzer
end type
type gb_sql_analysis from groupbox within w_exf_analyzer
end type
end forward

global type w_exf_analyzer from window
integer width = 5920
integer height = 2748
boolean titlebar = true
string title = "EXF Analyzer"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
long backcolor = 67108864
string icon = "exf_analyzer.ico"
boolean center = true
event ue_show ( any aa_data )
cb_fire_update_statement cb_fire_update_statement
cb_show_sql_select cb_show_sql_select
cb_show_dw_syntax cb_show_dw_syntax
cb_show_data cb_show_data
cb_save_disk cb_save_disk
cb_export_disk cb_export_disk
cb_db_connect_manual cb_db_connect_manual
cb_db_connect_odbc cb_db_connect_odbc
cb_load_disk cb_load_disk
dw_log dw_log
st_key st_key
st_id st_id
cb_paste cb_paste
cb_load_server cb_load_server
sle_key sle_key
sle_file sle_file
r_data r_data
cb_show_update_statement cb_show_update_statement
gb_server gb_server
gb_local gb_local
gb_connection gb_connection
gb_sql_analysis gb_sql_analysis
end type
global w_exf_analyzer w_exf_analyzer

type variables
w_exf_error_analyzer iw_analyzer

protected u_exf_db_transaction pu_trans

end variables

forward prototypes
public subroutine of_open_exception (u_exf_error_data au_error)
public subroutine of_close_exception ()
end prototypes

event ue_show(any aa_data);//Callback vom Error-Analyzer
u_exf_blob lu_blob
u_exf_error_data lu_error_dummy
lu_error_dummy = create u_exf_error_data

gb_sql_analysis.event ue_hide()

if classname(aa_data) = 'u_exf_blob' then
	lu_blob = aa_data
	
	if lu_blob.is_type = lu_error_dummy.CS_COMPLEX_DATA_DATAOBJECT then
		gb_sql_analysis.event ue_show()
	end if
end if

end event

public subroutine of_open_exception (u_exf_error_data au_error);of_close_exception()

openwithparm(iw_analyzer, au_error)
iw_analyzer.of_set_callback_objects(this, dw_log)
iw_analyzer.event ue_expand()
iw_analyzer.x = r_data.x
iw_analyzer.y = r_data.y
iw_analyzer.width = r_data.width
iw_analyzer.height = r_data.height

end subroutine

public subroutine of_close_exception ();
if isvalid(iw_analyzer) then
	close(iw_analyzer)
end if
end subroutine

on w_exf_analyzer.create
this.cb_fire_update_statement=create cb_fire_update_statement
this.cb_show_sql_select=create cb_show_sql_select
this.cb_show_dw_syntax=create cb_show_dw_syntax
this.cb_show_data=create cb_show_data
this.cb_save_disk=create cb_save_disk
this.cb_export_disk=create cb_export_disk
this.cb_db_connect_manual=create cb_db_connect_manual
this.cb_db_connect_odbc=create cb_db_connect_odbc
this.cb_load_disk=create cb_load_disk
this.dw_log=create dw_log
this.st_key=create st_key
this.st_id=create st_id
this.cb_paste=create cb_paste
this.cb_load_server=create cb_load_server
this.sle_key=create sle_key
this.sle_file=create sle_file
this.r_data=create r_data
this.cb_show_update_statement=create cb_show_update_statement
this.gb_server=create gb_server
this.gb_local=create gb_local
this.gb_connection=create gb_connection
this.gb_sql_analysis=create gb_sql_analysis
this.Control[]={this.cb_fire_update_statement,&
this.cb_show_sql_select,&
this.cb_show_dw_syntax,&
this.cb_show_data,&
this.cb_save_disk,&
this.cb_export_disk,&
this.cb_db_connect_manual,&
this.cb_db_connect_odbc,&
this.cb_load_disk,&
this.dw_log,&
this.st_key,&
this.st_id,&
this.cb_paste,&
this.cb_load_server,&
this.sle_key,&
this.sle_file,&
this.r_data,&
this.cb_show_update_statement,&
this.gb_server,&
this.gb_local,&
this.gb_connection,&
this.gb_sql_analysis}
end on

on w_exf_analyzer.destroy
destroy(this.cb_fire_update_statement)
destroy(this.cb_show_sql_select)
destroy(this.cb_show_dw_syntax)
destroy(this.cb_show_data)
destroy(this.cb_save_disk)
destroy(this.cb_export_disk)
destroy(this.cb_db_connect_manual)
destroy(this.cb_db_connect_odbc)
destroy(this.cb_load_disk)
destroy(this.dw_log)
destroy(this.st_key)
destroy(this.st_id)
destroy(this.cb_paste)
destroy(this.cb_load_server)
destroy(this.sle_key)
destroy(this.sle_file)
destroy(this.r_data)
destroy(this.cb_show_update_statement)
destroy(this.gb_server)
destroy(this.gb_local)
destroy(this.gb_connection)
destroy(this.gb_sql_analysis)
end on

type cb_fire_update_statement from commandbutton within w_exf_analyzer
boolean visible = false
integer x = 1134
integer y = 192
integer width = 695
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Fire Update Statement"
end type

event clicked;
u_exf_db_transaction lu_trans
if isvalid(pu_trans) then
	lu_trans = pu_trans
else
	lu_trans = create u_exf_db_transaction
	lu_trans.of_set_logger(dw_log)
	lu_trans.of_connect()
end if
	
lu_trans.ibo_abort_dbactions = false
try
	iw_analyzer.of_set_transobject(lu_trans)
	iw_analyzer.dw_exf_data.update()
finally
	lu_trans.ibo_abort_dbactions = true
end try
end event

type cb_show_sql_select from commandbutton within w_exf_analyzer
boolean visible = false
integer x = 1134
integer y = 384
integer width = 695
integer height = 96
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show SQL select"
end type

event clicked;dw_log.of_push_sqlselect(iw_analyzer.dw_exf_data.describe('datawindow.table.select'))
end event

type cb_show_dw_syntax from commandbutton within w_exf_analyzer
boolean visible = false
integer x = 1134
integer y = 480
integer width = 695
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show DW syntax"
end type

event clicked;dw_log.of_push_dw_syntax(iw_analyzer.dw_exf_data.describe('datawindow.syntax'))
end event

type cb_show_data from commandbutton within w_exf_analyzer
boolean visible = false
integer x = 1134
integer y = 288
integer width = 695
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save DW Data to Disk"
end type

event clicked;

iw_analyzer.dw_exf_data.saveas()

end event

type cb_save_disk from commandbutton within w_exf_analyzer
integer x = 549
integer y = 672
integer width = 457
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save to file"
end type

event clicked;u_exf_error_data lu_data 
u_exf_serialization lu_serialization
blob lbl_data
string ls_file
string ls_filepath
integer li_file
lu_serialization = create u_exf_serialization
string ls_currentdir
if not isvalid(iw_analyzer) then
	return
end if

lu_data = iw_analyzer.tv_data.event ue_get_error()
if not isvalid(lu_data) then
	return
end if

lbl_data = lu_serialization.of_serialize(lu_data)

ls_currentdir = getcurrentdirectory()
try
	if getfilesavename('Save exception', ls_filepath, ls_file, 'exf', 'Informaticon Exceptions (*.exf),*.exf') <> 1 then
		return
	end if
finally
	changedirectory(ls_currentdir)
end try

li_file = fileopen(ls_filepath,  streammode!, write!, lockreadwrite!, replace!)
if li_file < 1 then
	messagebox('Error', 'Fileopen failed')
	return
end if

try
	if filewriteex(li_file, lbl_data) < 0 then
		messagebox('Error', 'Filewrite failed')
		return
	end if
finally
	fileclose(li_file)
end try	
end event

type cb_export_disk from commandbutton within w_exf_analyzer
integer x = 549
integer y = 800
integer width = 457
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Export to folder"
end type

event clicked;if isvalid(iw_analyzer) then
	gu_e.of_save_to_folder(iw_analyzer.tv_data.event ue_get_error())
end if
end event

type cb_db_connect_manual from commandbutton within w_exf_analyzer
integer x = 37
integer y = 672
integer width = 402
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "DBParm"
end type

event clicked;string ls_param
ls_param += "connectstring='driver=sql anywhere 16;databasefile=C:\helper.db;uid=org;pwd=sql;compress=no;idle=1440',CommitOnDisconnect='No',DisableBind=1'"
openwithparm(w_exf_inputbox, 'Enter DB Connection Parameter;' + ls_param)
ls_param = message.stringparm
if len(ls_param) = 0 then
	return
end if
pu_trans = create u_exf_db_transaction
pu_trans.of_set_logger(dw_log)
pu_trans.of_connect(ls_param)
end event

type cb_db_connect_odbc from commandbutton within w_exf_analyzer
integer x = 37
integer y = 544
integer width = 402
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "ODBC"
end type

event clicked;
if isvalid(pu_trans) then
	disconnect using pu_trans;
end if

pu_trans = create u_exf_db_transaction
pu_trans.of_set_logger(dw_log)
pu_trans.of_connect('')

end event

type cb_load_disk from commandbutton within w_exf_analyzer
integer x = 549
integer y = 544
integer width = 457
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Load from file"
end type

event clicked;u_exf_error_data lu_data 
u_exf_serialization lu_serialization
blob lbl_data
string ls_file
string ls_filepath
integer li_file
lu_serialization = create u_exf_serialization
string ls_currentdir
ls_currentdir = getcurrentdirectory()

try
	if getfileopenname('Open exception', ls_filepath, ls_file, 'exf', 'Informaticon Exceptions (*.exf),*.exf') <> 1 then
		return
	end if
	
	li_file = fileopen(ls_filepath,  streammode!, read!, shared!, replace!)
	if li_file < 1 then
		messagebox('Error', 'Fileopen failed')
		return
	end if
finally
	changedirectory(ls_currentdir)
end try

try
	if filereadex(li_file, lbl_data) < 0 then
		messagebox('Error', 'Fileread failed')
		return
	end if

	lu_data = lu_serialization.of_deserialize_error_data(lbl_data)
	of_open_exception(lu_data)
	
catch (u_exf_ex lu_e)
	gu_e.of_display(gu_e.iu_as.of_re(gu_e.of_new_error() &
		.of_push(populateerror(0, 'Daten konnten nicht geladen werden')) &
		.of_set_nested_error(lu_e) &
	))
finally
	fileclose(li_file)
end try	
end event

type dw_log from u_exf_log within w_exf_analyzer
integer x = 1902
integer y = 32
integer width = 3986
integer height = 896
integer taborder = 70
boolean hscrollbar = true
boolean resizable = true
boolean border = false
string icon = "AppIcon!"
borderstyle borderstyle = stylebox!
end type

event doubleclicked;call super::doubleclicked;string ls_data
if isvalid(dwo) then
	if right(dwo.name, 2) <> '_t' then
		ls_data = this.describe("evaluate('" + dwo.name + "', " + string(row) + ")")
		::clipboard(ls_data)
	end if
end if
end event

type st_key from statictext within w_exf_analyzer
integer x = 37
integer y = 192
integer width = 183
integer height = 96
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Key"
boolean focusrectangle = false
end type

type st_id from statictext within w_exf_analyzer
integer x = 37
integer y = 64
integer width = 183
integer height = 96
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "ID"
boolean focusrectangle = false
end type

type cb_paste from commandbutton within w_exf_analyzer
integer x = 219
integer y = 320
integer width = 329
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Paste"
end type

event clicked;string ls_icon = 'exf_analyzer.ico'
parent.icon = ls_icon
string ls_clip
ls_clip = clipboard()
if pos(ls_clip, ' / ') > 0 &
and pos(ls_clip, ' / ') = lastpos(ls_clip, ' / ') &
and len(ls_clip) < 50 then
	sle_file.text = left(ls_clip, pos(ls_clip, ' / ') -1)
	sle_key.text = mid(ls_clip, pos(ls_clip, ' / ') + 3)
end if
end event

type cb_load_server from commandbutton within w_exf_analyzer
integer x = 585
integer y = 320
integer width = 366
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Load"
boolean default = true
end type

event clicked;try
	of_open_exception(gu_e.of_get_app_adapter().of_download(sle_file.text, sle_key.text))
catch(u_exf_ex lu_e)
	gu_e.of_display(gu_e.iu_as.of_re(gu_e.of_new_error() &
		.of_push(populateerror(0, 'Daten konnten nicht geladen werden')) &
		.of_set_nested_error(lu_e) &
	))
end try
end event

type sle_key from singlelineedit within w_exf_analyzer
integer x = 219
integer y = 192
integer width = 731
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_file from singlelineedit within w_exf_analyzer
integer x = 219
integer y = 64
integer width = 731
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type r_data from rectangle within w_exf_analyzer
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 1073741824
integer y = 960
integer width = 5888
integer height = 1664
end type

type cb_show_update_statement from commandbutton within w_exf_analyzer
boolean visible = false
integer x = 1134
integer y = 96
integer width = 695
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show Update Statement"
end type

event clicked;
u_exf_db_transaction lu_trans
if isvalid(pu_trans) then
	lu_trans = pu_trans
else
	lu_trans = create u_exf_db_transaction
	lu_trans.of_set_logger(dw_log)
	lu_trans.of_connect()
end if

lu_trans.ibo_abort_dbactions = true
iw_analyzer.of_set_transobject(lu_trans)
iw_analyzer.dw_exf_data.update()

end event

type gb_server from groupbox within w_exf_analyzer
integer width = 1061
integer height = 448
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Load from Server"
end type

type gb_local from groupbox within w_exf_analyzer
integer x = 512
integer y = 448
integer width = 549
integer height = 480
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Load/Save locally"
end type

type gb_connection from groupbox within w_exf_analyzer
integer y = 448
integer width = 475
integer height = 480
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "DB Connection"
end type

type gb_sql_analysis from groupbox within w_exf_analyzer
event ue_hide ( )
event ue_show ( )
integer x = 1097
integer width = 768
integer height = 640
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Analysis"
end type

event ue_hide();cb_show_dw_syntax.hide()
cb_fire_update_statement.hide()
cb_show_sql_select.hide()
cb_show_data.hide()
cb_show_update_statement.hide()
end event

event ue_show();cb_show_dw_syntax.show()
cb_fire_update_statement.show()
cb_show_sql_select.show()
cb_show_data.show()
cb_show_update_statement.show()
end event


