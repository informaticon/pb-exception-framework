forward
global type w_tst_testframework from window
end type
type dw_testcase from datawindow within w_tst_testframework
end type
type mle_log from multilineedit within w_tst_testframework
end type
type dw_testcases from datawindow within w_tst_testframework
end type
type st_cli_parm from structure within w_tst_testframework
end type
type iu_tst_context from u_tst_context within w_tst_testframework
end type
end forward

type st_cli_parm from structure
	boolean		bo_run_all
	boolean		bo_quiet
	string		s_run_some[]
	boolean		bo_verbose
	string		s_dir_testdata
end type

global type w_tst_testframework from window
boolean visible = false
integer width = 7621
integer height = 2656
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean righttoleft = true
boolean center = true
event ue_run_all_and_close ( )
event ue_run_some ( string as_tests[] )
dw_testcase dw_testcase
mle_log mle_log
dw_testcases dw_testcases
iu_tst_context iu_tst_context
end type
global w_tst_testframework w_tst_testframework

type variables
protected u_tst_testcase pu_tst_testcases[]

protected throwable pth_exceptions[]
private st_cli_parm pst_parm
end variables

forward prototypes
protected function u_tst_stringarray pf_explode (string as_string, string as_separator)
protected function long of_add_exception (throwable ath_exception)
public subroutine of_load (long al_testcase_index)
public function boolean of_run (long al_testcase_index)
public function boolean of_run (long al_testcase_index, string as_test)
public function u_tst_stringarray of_get_libraries (string as_target_filepath)
protected function st_cli_parm pf_parse_command (string as_commandline)
protected function string pf_find_working_directory (string as_hint)
end prototypes

event ue_run_all_and_close();long ll_i
long ll_ret = 0
for ll_i = 1 to dw_testcases.rowcount()
	if not of_run(dw_testcases.getitemnumber(ll_i, 'arrayindex')) then
		ll_ret += 1
	end if
next
iu_tst_context.of_close_with_exitcode(ll_ret)


end event

event ue_run_some(string as_tests[]);//Zweck		Wie ue_run_all, startet jedoch nur ausgewählte Tests
//				as_tests kann Suiten (z.B. t_net_httpclient_simple) oder einzelne Tests
//				(z.B. t_net_httpclient_simple.te_informaticon_ca) enthalten
//Argument	as_tests[]	
//Erstellt	2023-03-31 Simon Reichenbach

long ll_i
long ll_e
long ll_ret = 0
string ls_testsuite
string ls_testcase
for ll_i = 1 to upperbound(as_tests)
	if pos(as_tests[ll_i], '.') > 0 then
		ls_testsuite = left(as_tests[ll_i], pos(as_tests[ll_i], '.') - 1)
		ls_testcase = mid(as_tests[ll_i], pos(as_tests[ll_i], '.') + 1)
	else
		ls_testsuite = as_tests[ll_i]
		ls_testcase = ''
	end if

	for ll_e = 1 to dw_testcases.rowcount()
		if dw_testcases.getitemstring(ll_e, 'name') = ls_testsuite then
			if ls_testcase = '' then
				if not of_run(dw_testcases.getitemnumber(ll_e, 'arrayindex')) then
					ll_ret += 1
				end if
			else
				if not of_run(dw_testcases.getitemnumber(ll_e, 'arrayindex'), ls_testcase) then
					ll_ret += 1
				end if
			end if
		end if
	next
next

iu_tst_context.of_close_with_exitcode(ll_ret)
	

end event

protected function u_tst_stringarray pf_explode (string as_string, string as_separator);//Zweck		Nimmt as_string auseinander und füllt ihn in den Array as_list ab
//Hinweis	Ein Separator am Schluss des Strings wird ignoriert. 
//				Es wird nicht wie z.Bsp. bei einem CSV noch ein zusätzlicher leerer Array-Eintrag hinzugefügt.
//				Dies wird so belassen, damit bestehender Code nicht plötzlich anders reagiert.

long ll_pos1 = 1, ll_pos2, ll_count = 1
string ls_piece, ls_leer[]
u_tst_stringarray lt_return
lt_return = create u_tst_stringarray

do while ll_pos2 < len(as_string)
	ll_pos2 = pos(as_string, as_separator, ll_pos1)
	//2018-07-09 Martin Abplanalp, Ticket 15713: Leere Elemente wurden nicht korrekt verarbeitet
	//if ll_pos2 <= ll_pos1 then
	//	ll_pos2 = len(as_string) + 1
	//end if
	if ll_pos2 = 0 then ll_pos2 = len(as_string) + 1
	
	ls_piece = mid(as_string, ll_pos1, ll_pos2 - ll_pos1)
	lt_return.is_data[ll_count] = ls_piece
	ll_count++
	ll_pos1 = ll_pos2 + len(as_separator)	
loop

return lt_return
end function

protected function long of_add_exception (throwable ath_exception);
pth_exceptions[upperbound(pth_exceptions) + 1] = ath_exception
return upperbound(pth_exceptions)
end function

public subroutine of_load (long al_testcase_index);
dw_testcase.reset()
dw_testcase.event ue_add_tests(pu_tst_testcases[al_testcase_index].of_get_events(), al_testcase_index)

end subroutine

public function boolean of_run (long al_testcase_index);string ls_events[]
long ll_i
long ll_cpu
boolean lbo_all_ok = true

of_load(al_testcase_index)

for ll_i = 1 to dw_testcase.rowcount()
	try
		if not of_run(al_testcase_index, dw_testcase.getitemstring(ll_i, 'test')) then
			lbo_all_ok = false
		end if
	finally
		yield()
		garbagecollect()
	end try
next

return lbo_all_ok
end function

public function boolean of_run (long al_testcase_index, string as_test);long ll_cpu

ll_cpu = cpu()
iu_tst_context.of_prepare(as_test, pu_tst_testcases[al_testcase_index])

try
	pu_tst_testcases[al_testcase_index].of_setup(iu_tst_context)
	pu_tst_testcases[al_testcase_index].triggerevent(as_test)
	iu_tst_context.event ue_set_result_ok(cpu() - ll_cpu)
	return true
catch (throwable lth)
	iu_tst_context.event ue_set_result(false, cpu() - ll_cpu, lth.getmessage(), lth)
	return false
finally
	pu_tst_testcases[al_testcase_index].of_teardown()
end try
end function

public function u_tst_stringarray of_get_libraries (string as_target_filepath);long ll_i
integer li_file
string ls_target_source
string ls_base_path
u_tst_stringarray lu_ret
lu_ret = u_tst_stringarray

ls_base_path = left(as_target_filepath, lastpos(as_target_filepath, '\'))

li_file = fileopen(as_target_filepath, linemode!)
do while filereadex(li_file, ls_target_source) > 0
	if not left(ls_target_source, 7) = 'LibList' then
		continue
	end if
	ls_target_source = mid(ls_target_source, pos(ls_target_source, '"') + 1, lastpos(ls_target_source, '"') - pos(ls_target_source, '"') - 1)
	lu_ret = pf_explode(ls_target_source, ';')
loop
fileclose(li_file)

//Pfad in absoluten Pfad umwandern
for ll_i = 1 to lu_ret.of_get_size()
	lu_ret.of_set(ll_i, ls_base_path + lu_ret.of_get(ll_i))
next

return lu_ret
end function

protected function st_cli_parm pf_parse_command (string as_commandline);long ll_i = 1
string ls_commands[]
st_cli_parm lst_ret

iu_tst_context.iu_service.of_explode(as_commandline, ' ', ls_commands)
do while ll_i <= upperbound(ls_commands)
	choose case ls_commands[ll_i]
		case '--run-all'
			lst_ret.bo_run_all = true
		case '--quiet'
			lst_ret.bo_quiet = true
		case '--run'
			if ll_i < upperbound(ls_commands) then
				iu_tst_context.iu_service.of_explode(ls_commands[ll_i+1], ',', lst_ret.s_run_some)
				ll_i += 1
			end if
		case '--verbose'
			lst_ret.bo_verbose = true
		case '--testdata-dir'
			if ll_i < upperbound(ls_commands) then
				lst_ret.s_dir_testdata = ls_commands[ll_i+1]
				if right(lst_ret.s_dir_testdata, 1) <> '\' then
					lst_ret.s_dir_testdata += '\'
				end if
				ll_i += 1
			end if
	end choose
	ll_i += 1
loop

return lst_ret
end function

protected function string pf_find_working_directory (string as_hint);if len(as_hint) > 0 and directoryexists(as_hint + '..\lib') then
	return as_hint + '..\lib'
end if

if directoryexists(getcurrentdirectory() + '..\lib') then
	return getcurrentdirectory() + '..\lib'
end if

if directoryexists(getcurrentdirectory() + '\lib') then
	return getcurrentdirectory() + '\lib'
end if
end function

on w_tst_testframework.create
this.dw_testcase=create dw_testcase
this.mle_log=create mle_log
this.dw_testcases=create dw_testcases
this.iu_tst_context=create iu_tst_context
this.Control[]={this.dw_testcase,&
this.mle_log,&
this.dw_testcases}
end on

on w_tst_testframework.destroy
destroy(this.dw_testcase)
destroy(this.mle_log)
destroy(this.dw_testcases)
destroy(this.iu_tst_context)
end on

event open;string ls_testcases[]
string ls_testcase[]
string ls_libraries[]

long ll_i
long ll_l
long ll_row
constant long LCL_ELEM_CLASSNAME = 1
constant long LCL_ELEM_MODIFIED = 2
constant long LCL_ELEM_COMMENT = 3
constant long LCL_ELEM_OBJECTTYPE = 4

pst_parm = pf_parse_command(message.stringparm)
iu_tst_context.event ue_init()
iu_tst_context.ibo_verbose = pst_parm.bo_verbose

//2022-08-18 Simon Reichenbach, Working directory wechseln ins lib, damit Umgebung der normalen Umgebung der zu
//											testenden Bibliotheken ist
changedirectory('..\lib')

//ls_libraries = of_get_libraries('C:\a3\erp.win.base.main\lib\a3.pbt').of_push_back('test_inf1.pbl').is_data

ls_libraries = pf_explode(getlibrarylist(), ',').is_data
for ll_l = 1 to upperbound(ls_libraries)
	//mle_log.event ue_log('added library ' + ls_libraries[ll_l] + ' result: ' + string(addtolibrarylist(ls_libraries[ll_l])))
	ls_testcases = pf_explode(librarydirectoryex(ls_libraries[ll_l] , diruserobject!), '~n').is_data //name ~t date/time modified ~t comments ~t   type~n
	for ll_i = 1 to upperbound(ls_testcases)
		ls_testcase = pf_explode(ls_testcases[ll_i], '~t').is_data
		if left(ls_testcase[LCL_ELEM_CLASSNAME], 2) = 't_' then
			pu_tst_testcases[upperbound(pu_tst_testcases) + 1] = create using ls_testcase[LCL_ELEM_CLASSNAME]
			
			ll_row = dw_testcases.insertrow(0)
			dw_testcases.setitem(ll_row, 'name', ls_testcase[LCL_ELEM_CLASSNAME])
			dw_testcases.setitem(ll_row, 'modified', datetime(ls_testcase[LCL_ELEM_MODIFIED]))
			dw_testcases.setitem(ll_row, 'comment', ls_testcase[LCL_ELEM_COMMENT])
			dw_testcases.setitem(ll_row, 'objecttype', ls_testcase[LCL_ELEM_OBJECTTYPE])
			dw_testcases.setitem(ll_row, 'arrayindex', upperbound(pu_tst_testcases))
		end if
	next
next

if not pst_parm.bo_quiet then
	this.show()
end if

if pst_parm.bo_run_all then
	this.post event ue_run_all_and_close()
end if

if upperbound(pst_parm.s_run_some) > 0 then
	this.post event ue_run_some(pst_parm.s_run_some)
end if

end event

type dw_testcase from datawindow within w_tst_testframework
event type long ue_add_test ( string as_test_name,  long al_testcase_index )
event ue_set_result ( string as_test_name,  u_tst_testcase au_tst_testcase,  boolean abo_result,  long al_time_taken,  string as_message,  throwable ath_exception )
event ue_set_result_ok ( string as_test_name,  u_tst_testcase au_tst_testcase,  long al_time_taken )
event ue_add_tests ( u_tst_stringarray as_test_names,  long al_testcase_index )
event type long ue_get_test_row ( string as_test,  u_tst_testcase au_tst_testcase )
integer x = 1975
integer y = 32
integer width = 2048
integer height = 2496
integer taborder = 20
string title = "none"
string dataobject = "d_tst_testcase"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long ue_add_test(string as_test_name, long al_testcase_index);long ll_row

ll_row = this.find("test='" + as_test_name + "'", 1, this.rowcount())
if ll_row <= 0 then
	ll_row = this.insertrow(0)
	this.setitem(ll_row, 'test', as_test_name)
	this.setitem(ll_row, 'arrayindex', al_testcase_index)
end if

return ll_row
end event

event ue_set_result(string as_test_name, u_tst_testcase au_tst_testcase, boolean abo_result, long al_time_taken, string as_message, throwable ath_exception);long ll_row
pth_exceptions[upperbound(pth_exceptions) + 1] = ath_exception

ll_row = this.event ue_get_test_row(as_test_name, au_tst_testcase)
if ll_row = 0 then
	//todo: error handling
end if

if abo_result then
	this.setitem(ll_row, 'result', 1)
else
	this.setitem(ll_row, 'result', 0)
end if

this.setitem(ll_row, 'message', as_message)
this.setitem(ll_row, 'exception', upperbound(pth_exceptions))
this.setitem(ll_row, 'time', al_time_taken)
iu_tst_context.event ue_log_result(abo_result, classname(au_tst_testcase), as_test_name, as_message, ath_exception)
	
end event

event ue_set_result_ok(string as_test_name, u_tst_testcase au_tst_testcase, long al_time_taken);long ll_row

ll_row = this.event ue_get_test_row(as_test_name, au_tst_testcase)
if ll_row = 0 then
	//todo: error handling
end if

this.setitem(ll_row, 'result', 1)
this.setitem(ll_row, 'message', 'ok')
this.setitem(ll_row, 'time', al_time_taken)

throwable lth_err
iu_tst_context.event ue_log_result(true, classname(au_tst_testcase), as_test_name, '', lth_err)

end event

event ue_add_tests(u_tst_stringarray as_test_names, long al_testcase_index);
long ll_i

for ll_i = 1 to as_test_names.of_get_size()
	this.event ue_add_test(as_test_names.of_get(ll_i), al_testcase_index)
next
end event

event type long ue_get_test_row(string as_test, u_tst_testcase au_tst_testcase);
long ll_row

ll_row = this.find("test='" + as_test + "'", 1, this.rowcount())
do while ll_row > 0
	if pu_tst_testcases[this.getitemnumber(ll_row, 'arrayindex')] = au_tst_testcase then
		return ll_row
	end if
	
	ll_row = this.find("test='" + as_test + "'", ll_row + 1, this.rowcount())
loop

return 0
end event

event buttonclicked;

choose case dwo.name
	case 'b_ex'
		if this.getitemnumber(row, 'exception') > 0 then
			gu_e.of_display(pth_exceptions[this.getitemnumber(row, 'exception')])
		end if
		
	case 'b_run'
		of_run(this.getitemnumber(row, 'arrayindex'), this.getitemstring(row, 'test'))
		
end choose
end event

type mle_log from multilineedit within w_tst_testframework
event ue_log ( string as_message )
integer x = 4059
integer y = 32
integer width = 3474
integer height = 2496
integer taborder = 20
integer textsize = -9
integer weight = 400
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
string text = " "
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_log(string as_message);
this.text = string(now(), 'hh:mm:ss') + ' ' + as_message + '~r~n' + this.text
end event

type dw_testcases from datawindow within w_tst_testframework
integer x = 37
integer y = 32
integer width = 1902
integer height = 2496
integer taborder = 10
string title = "none"
string dataobject = "d_tst_testcases"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;choose case dwo.name 
	case 'b_run'
		if of_run(this.getitemnumber(row, 'arrayindex')) then
			this.setitem(row, 'status', 1)
		else
			this.setitem(row, 'status', 0)
		end if
		
	case 'b_load'
		of_load(this.getitemnumber(row, 'arrayindex'))
		
end choose
end event

type iu_tst_context from u_tst_context within w_tst_testframework descriptor "pb_nvo" = "true" 
end type

on iu_tst_context.create
call super::create
end on

on iu_tst_context.destroy
call super::destroy
end on

event ue_set_result;call super::ue_set_result;dw_testcase.event ue_set_result(ps_function_name, pu_tst_testcase, abo_result, al_time_taken, as_message, ath_exception)
end event

event ue_log;call super::ue_log;string ls_function_name
ls_function_name = ps_function_name
if isnull(ls_function_name) then ls_function_name = 'NULL!'
if isnull(as_message) then as_message = 'NULL!'

pu_messagebuffer.of_push_back(ps_function_name + ': ' + as_message)
mle_log.event ue_log(ps_function_name + ': ' + as_message)

end event

event ue_set_result_ok;call super::ue_set_result_ok;dw_testcase.event ue_set_result_ok(ps_function_name, pu_tst_testcase, al_time_taken)
end event

event ue_get_dir_testdata;call super::ue_get_dir_testdata;if len(pst_parm.s_dir_testdata) > 0 then
	return pst_parm.s_dir_testdata
else
	return ancestorreturnvalue
end if
end event

