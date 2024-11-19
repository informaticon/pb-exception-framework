forward
global type t_exf_error_data from u_tst_testcase
end type
end forward

global type t_exf_error_data from u_tst_testcase
event te_simple ( )
event te_stacktrace ( )
event te_of_to_string ( )
end type
global t_exf_error_data t_exf_error_data

type variables


end variables

event te_simple();
u_exf_error_data lu_ed
lu_ed = create u_exf_error_data

lu_ed.of_push('test123', 'test456')
pu_context.of_assert_equal( &
	lu_ed.of_get_value('test123'), &
	'test456', &
	'key-value pair was not stored correctly' &
)
end event

event te_stacktrace();string ls_expected
string ls_stacktrace
u_exf_error_data lu_err
lu_err = create u_exf_error_data

lu_err.of_set_stacktrace()
populateerror(0, 'INFO: Get line number and function name')
ls_expected = error.object + '.+' + error.objectevent + ': ' + string(error.line - 1)

ls_stacktrace = lu_err.of_get_stacktrace()
pu_context.event ue_log(ls_stacktrace)

pu_context.of_assert_contains(ls_stacktrace, {ls_expected}, 'Content of stacktrace ist not like expected')


end event

event te_of_to_string();//Zweck		Überprüft, ob die of_to_string-Funktion korrekt funktioniuer
//Erstellt	2022-08-18 Simon Reichenbach

u_exf_error_data lu_left
u_exf_error_data lu_right
u_exf_error_data lu_nested
userobject lu_dummy
lu_left = create u_exf_error_data
lu_right = create u_exf_error_data
lu_nested = create u_exf_error_data
lu_dummy = create userobject

lu_nested.of_set_message(0, 'Gugus')
lu_left.of_set_type('u_exf_ex')
lu_right.of_set_type('u_exf_ex')
lu_left.of_push('test123', 'test456')
lu_right.of_push('test123', 'test456')
if	lu_left.of_push(populateerror(0, 'testmessage')).typeof() = lu_right.of_push(populateerror(0, 'testmessage')).typeof() then
	//Dieses if statement ist nur dazu da, dass populateerror für lu_left und lu_right
	//auf der gleichen Zeile ausgeführt werden können (selbe Kontextinformtionen)
end if
lu_left.of_push('lu_dummy', lu_dummy)
lu_right.of_push('lu_dummy', lu_dummy)
lu_left.of_push('dwbuffer', primary!)
lu_right.of_push('dwbuffer', primary!)

pu_context.of_assert_equal(lu_left, lu_right, 'Left and right error_data should be equal but are not')

lu_right.of_set_type('u_exf_re')
pu_context.of_assert_not_equal(lu_left, lu_right, 'Type changed but objects are still treated as equal')
lu_right.of_set_type('u_exf_ex')
pu_context.of_assert_equal(lu_left, lu_right, 'Type change makes object not equal but should not')

lu_left.of_push('2nd value', 123)
pu_context.of_assert_not_equal(lu_left, lu_right, 'Value added but objects are still treated as equal')
lu_right.of_push('2nd value', 123)
pu_context.of_assert_equal(lu_left, lu_right, 'Value add makes object not equal but should not')

lu_right.of_set_message(42, 'Blöd')
pu_context.of_assert_not_equal(lu_left, lu_right, 'Message changed but objects are still treated as equal')
lu_right.of_set_message(lu_left.of_get_message_tbz(), lu_left.of_get_message())
pu_context.of_assert_equal(lu_left, lu_right, 'Message change makes object not equal but should not')

lu_left.of_set_nested_error(lu_nested)
pu_context.of_assert_not_equal(lu_left, lu_right, 'Nested error changed but objects are still treated as equal')
lu_right.of_set_nested_error(lu_nested)
pu_context.of_assert_equal(lu_left, lu_right, 'Nested error change makes object not equal but should not')

pu_context.event ue_log(lu_left.of_to_string())
end event

on t_exf_error_data.create
call super::create
end on

on t_exf_error_data.destroy
call super::destroy
end on

