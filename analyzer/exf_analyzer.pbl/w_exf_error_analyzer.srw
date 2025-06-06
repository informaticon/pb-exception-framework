forward
global type w_exf_error_analyzer from w_exf_error_message
end type
end forward

global type w_exf_error_analyzer from w_exf_error_message
boolean visible = false
integer height = 2836
boolean titlebar = false
string title = ""
boolean controlmenu = false
windowtype windowtype = child!
end type
global w_exf_error_analyzer w_exf_error_analyzer

type variables
protected w_exf_analyzer pw_parent
protected u_exf_log pu_log
protected u_exf_db_transaction pu_transobject
end variables

forward prototypes
protected subroutine pf_show (any aa_data)
public subroutine of_set_callback_objects (w_exf_analyzer aw_parent, u_exf_log au_log)
public subroutine of_set_transobject (u_exf_db_transaction au_transobject)
end prototypes

protected subroutine pf_show (any aa_data);
boolean lbo_confidential
u_exf_blob lu_blob
if isnull(aa_data) then return

if classname(aa_data) = 'u_exf_blob' then
	lu_blob = aa_data
	lbo_confidential = lu_blob.ibo_confidential
	if lu_blob.ibo_confidential then
		lu_blob.ibo_confidential = false
	end if
end if

super::pf_show(aa_data)

if isvalid(lu_blob) then
	lu_blob.ibo_confidential = lbo_confidential
end if

if isvalid(pw_parent) then
	pw_parent.event ue_show(aa_data)
end if



end subroutine

public subroutine of_set_callback_objects (w_exf_analyzer aw_parent, u_exf_log au_log);pw_parent = aw_parent
pu_log = au_log

end subroutine

public subroutine of_set_transobject (u_exf_db_transaction au_transobject);pu_transobject = au_transobject
dw_exf_data.settransobject(au_transobject)
end subroutine

on w_exf_error_analyzer.create
call super::create
end on

on w_exf_error_analyzer.destroy
call super::destroy
end on

type r_gray from w_exf_error_message`r_gray within w_exf_error_analyzer
end type

type st_upload from w_exf_error_message`st_upload within w_exf_error_analyzer
boolean visible = false
end type

type cb_send from w_exf_error_message`cb_send within w_exf_error_analyzer
boolean visible = false
end type

type cb_copy from w_exf_error_message`cb_copy within w_exf_error_analyzer
boolean visible = false
end type

type cb_save from w_exf_error_message`cb_save within w_exf_error_analyzer
boolean visible = false
end type

type cb_ok from w_exf_error_message`cb_ok within w_exf_error_analyzer
end type

type cb_more from w_exf_error_message`cb_more within w_exf_error_analyzer
boolean visible = false
end type

type st_title from w_exf_error_message`st_title within w_exf_error_analyzer
end type

type ip_icon from w_exf_error_message`ip_icon within w_exf_error_analyzer
end type

type mle_data from w_exf_error_message`mle_data within w_exf_error_analyzer
end type

type st_box from w_exf_error_message`st_box within w_exf_error_analyzer
end type

type dw_exf_data from w_exf_error_message`dw_exf_data within w_exf_error_analyzer
end type

event dw_exf_data::dberror;call super::dberror;pu_log.of_push_dberror(sqldbcode, sqlerrtext, sqlsyntax, buffer, row)

//3 -- Do not display the error message and ignore the Transactionobject's DBError event whether it is defined or not.
return 3
end event

event dw_exf_data::sqlpreview;call super::sqlpreview;pu_log.of_push_sqlpreview(request, sqltype, sqlsyntax, buffer, row)
if pu_transobject.ibo_abort_dbactions then
	return 2 //2 -- Skip this request and execute the next request
else
	return 0 //0 - Continue
end if

end event

type st_error from w_exf_error_message`st_error within w_exf_error_analyzer
end type

type tv_data from w_exf_error_message`tv_data within w_exf_error_analyzer
integer y = 832
integer height = 1952
end type


