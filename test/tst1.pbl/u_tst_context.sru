forward
global type u_tst_context from nonvisualobject
end type
type iu_service from u_tst_service within u_tst_context
end type
end forward

global type u_tst_context from nonvisualobject
event ue_log ( string as_message )
event ue_set_result ( boolean abo_result,  long al_time_taken,  string as_message,  throwable ath_exception )
event ue_set_result_ok ( long al_time_taken )
event ue_log_result ( boolean abo_ok,  string as_testsuite,  string as_test,  string as_message,  throwable ath_error )
event type string ue_get_dir_testdata ( )
event ue_init ( )
iu_service iu_service
end type
global u_tst_context u_tst_context

type variables
protected u_tst_stringarray pu_messagebuffer

protected string ps_testdata_dir
protected u_tst_testcase pu_tst_testcase
protected string ps_function_name

protected u_tst_win32_api pu_win
protected w_tst_visual_container pw_visual_container

public boolean ibo_verbose = false
end variables

forward prototypes
public function string of_get_filepath (string as_filename)
public subroutine of_assert (boolean abo_assertion, string as_message)
public subroutine of_assert_equal (any aa_value, any aa_value_expected, string as_message)
public subroutine of_assert_equal (powerobject apo_value, powerobject apo_value_expected, string as_message)
public subroutine of_prepare (string as_function_name, u_tst_testcase au_tst_testcase)
public subroutine of_assert_contains (string as_string, string as_patterns[], string as_message)
public subroutine of_assert_not_equal (powerobject apo_value_left, powerobject apo_value_right, string as_message)
public subroutine of_throw (string as_message)
public subroutine of_assert_contains (boolean abo_casesens, string as_string, string as_patterns[], string as_message)
public subroutine of_close_with_exitcode (unsignedlong aul_code)
public function dragobject of_spawn_visual (string as_object_type)
public subroutine of_despawn_visual (dragobject adrg_ibj)
end prototypes

event ue_log(string as_message);pu_messagebuffer.of_push_back(ps_function_name + ': ' + as_message)
end event

event ue_log_result(boolean abo_ok, string as_testsuite, string as_test, string as_message, throwable ath_error);string ls_log
if abo_ok then
	ls_log = ' OK: '
else
	ls_log = 'ERR: '
end if

if isnull(as_testsuite) then as_testsuite = 'NULL'
if isnull(as_test) then as_test = 'NULL'
if isnull(as_message) then as_message = 'NULL'

ls_log += as_testsuite + '.' + as_test + ': ' + as_message

if pu_win.of_is_console_connected() then
	pu_win.of_print_ln(ls_log)
	if ibo_verbose then
		try
			pu_win.of_print_ln(ath_error.dynamic of_get_error().of_to_string())
		catch(throwable lth)
			//nothing to do
		end try
	end if
else
	this.event ue_log(ls_log)
end if
end event

event type string ue_get_dir_testdata();//Callback function
return left(getcurrentdirectory(), lastpos(getcurrentdirectory(), '\') - 1)  + '\test\testdata\'
end event

event ue_init();ps_testdata_dir = this.event ue_get_dir_testdata()
pu_win = create u_tst_win32_api

if pu_win.of_is_console_connected() then
	pu_win.of_print_ln('Test-Log attached, begin testing')
end if
end event

public function string of_get_filepath (string as_filename);return ps_testdata_dir + as_filename
end function

public subroutine of_assert (boolean abo_assertion, string as_message);if isnull(abo_assertion) or not abo_assertion then
	throw(gu_e.iu_as.of_re(gu_e.of_new_error() & 
		.of_push(populateerror(0, as_message)) &
	))
end if
end subroutine

public subroutine of_assert_equal (any aa_value, any aa_value_expected, string as_message);if aa_value = aa_value_expected then
	return
end if

if isnull(aa_value) and isnull(aa_value_expected) then
	return
end if

throw(gu_e.iu_as.of_re(gu_e.of_new_error() & 
	.of_push(populateerror(0, as_message)) &
	.of_push('aa_value', aa_value) &
	.of_push('aa_value_expected', aa_value_expected) &
))

end subroutine

public subroutine of_assert_equal (powerobject apo_value, powerobject apo_value_expected, string as_message);if apo_value = apo_value_expected then
	return
end if

if isnull(apo_value) and isnull(apo_value_expected) then
	return
end if

try
	if apo_value.dynamic of_to_string() = apo_value_expected.dynamic of_to_string() then
		return
	end if
	throw(gu_e.iu_as.of_re(gu_e.of_new_error() &
		.of_push(populateerror(0, 'Values differ but should not')) &
	))
catch(runtimeerror lr_t)
	throw(gu_e.iu_as.of_re(gu_e.of_new_error() & 
		.of_push(populateerror(0, as_message)) &
		.of_set_nested_error(lr_t) &
		.of_push('apo_value', apo_value) &
		.of_push('apo_value_expected', apo_value_expected) &
	))
end try
end subroutine

public subroutine of_prepare (string as_function_name, u_tst_testcase au_tst_testcase);
ps_function_name = as_function_name
pu_tst_testcase	= au_tst_testcase
pu_messagebuffer = create u_tst_stringarray
end subroutine

public subroutine of_assert_contains (string as_string, string as_patterns[], string as_message);//Zweck		Sucht in einem String nach verschiedenen Schlüsselwörtern oder Kombinationen davon
//				Wirft eine Exception, wenn nicht alle Patterns gefunden werden
//				Die Reihenfolge in as_patterns wird nicht berücksichtigt
//Argument	as_string		String, welcher durchsucht werden soll
//				as_patterns[]	Array von Strings, welche in as_string vorkommen müssen
//				as_message		Fehlermeldung, welche geworfen werden soll, wenn as_pattern nicht in as_string vorkommt
//Erstellt	2022-07-14 Simon Reichenbach

long ll_i

for ll_i = 1 to upperbound(as_patterns)
	if pos(as_string, as_patterns[ll_i]) > 0 then
		//ok
	else
		throw(gu_e.iu_as.of_re(gu_e.of_new_error() & 
			.of_push(populateerror(0, as_message)) &
			.of_push('as_string', as_string) &
			.of_push('as_patterns[ll_i]', as_patterns[ll_i]) &
			.of_push('as_patterns', as_patterns) &
		))
	end if
next

end subroutine

public subroutine of_assert_not_equal (powerobject apo_value_left, powerobject apo_value_right, string as_message);if apo_value_left = apo_value_right &
or isnull(apo_value_left) and isnull(apo_value_right) then
	throw(gu_e.iu_as.of_re(gu_e.of_new_error() & 
		.of_push(populateerror(0, as_message)) &
		.of_push('apo_value_left', apo_value_left) &
		.of_push('apo_value_right', apo_value_right) &
	))
end if

try
	if apo_value_left.dynamic of_to_string() = apo_value_right.dynamic of_to_string() then
		throw(gu_e.iu_as.of_re(gu_e.of_new_error() & 
			.of_push(populateerror(0, as_message)) &
			.of_push('apo_value_left', apo_value_left) &
			.of_push('apo_value_right', apo_value_right) &
		))
	end if
catch(runtimeerror lr_t)
	return //nothing to do, because of_to_string() is not implemented
end try
end subroutine

public subroutine of_throw (string as_message);throw(gu_e.iu_as.of_re(gu_e.of_new_error() & 
	.of_push(populateerror(0, as_message)) &
))

end subroutine

public subroutine of_assert_contains (boolean abo_casesens, string as_string, string as_patterns[], string as_message);//Zweck		Sucht in einem String nach verschiedenen Schlüsselwörtern oder Kombinationen davon
//				Wirft eine Exception, wenn nicht alle Patterns gefunden werden
//				Die Reihenfolge in as_patterns wird nicht berücksichtigt
//Argument	abo_casesens	Case sensitive (true) oder nicht (false)
//				as_string		String, welcher durchsucht werden soll
//				as_patterns[]	Array von Strings, welche in as_string vorkommen müssen
//				as_message		Fehlermeldung, welche geworfen werden soll, wenn as_pattern nicht in as_string vorkommt
//Erstellt	2022-07-14 Simon Reichenbach

long ll_i
string ls_detail
if not abo_casesens then
	as_string = lower(as_string)
end if

for ll_i = 1 to upperbound(as_patterns)
	if abo_casesens then
		if pos(as_string, as_patterns[ll_i]) > 0 then
			continue
		end if
	else
		if pos(as_string, lower(as_patterns[ll_i])) > 0 then
			continue
		end if
	end if

	throw(gu_e.iu_as.of_re(gu_e.of_new_error() & 
		.of_push(populateerror(0, as_message)) &
		.of_push('as_string', as_string) &
		.of_push('as_patterns[ll_i]', as_patterns[ll_i]) &
		.of_push('as_patterns', as_patterns) &
	))
next

end subroutine

public subroutine of_close_with_exitcode (unsignedlong aul_code);pu_win.of_exit(aul_code)
end subroutine

public function dragobject of_spawn_visual (string as_object_type);if not isvalid(pw_visual_container) then
	open(pw_visual_container)
end if

return pw_visual_container.of_spawn_visual(as_object_type)
end function

public subroutine of_despawn_visual (dragobject adrg_ibj);pw_visual_container.of_despawn_visual(adrg_ibj)
end subroutine

on u_tst_context.create
call super::create
this.iu_service=create iu_service
TriggerEvent( this, "constructor" )
end on

on u_tst_context.destroy
TriggerEvent( this, "destructor" )
call super::destroy
destroy(this.iu_service)
end on

type iu_service from u_tst_service within u_tst_context descriptor "pb_nvo" = "true" 
end type

on iu_service.create
call super::create
end on

on iu_service.destroy
call super::destroy
end on


