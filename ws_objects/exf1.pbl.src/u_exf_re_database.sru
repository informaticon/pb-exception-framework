$PBExportHeader$u_exf_re_database.sru
forward
global type u_exf_re_database from u_exf_re
end type
end forward

global type u_exf_re_database from u_exf_re
end type
global u_exf_re_database u_exf_re_database

forward prototypes
public function u_exf_re_database of_set_sqlerror (long al_code, string as_sqlerrortext, string as_sqlsyntax)
public function long of_get_sql_code ()
public function string of_get_sql_errortext ()
public function string of_get_sql_syntax ()
end prototypes

public function u_exf_re_database of_set_sqlerror (long al_code, string as_sqlerrortext, string as_sqlsyntax);
pu_error.of_push('sql.code', al_code)
pu_error.of_push('sql.sqlerrortext', as_sqlerrortext)
pu_error.of_push('sql.sqlsyntax', as_sqlsyntax)
pu_error.of_push('sql.sqlsyntax', blob(as_sqlsyntax, encodingutf8!)) //Zusätzlich als blob abspeichern, für den Fall, dass Platz in Key-Val Store nicht reicht

return this
end function

public function long of_get_sql_code ();return long(pu_error.of_get_value('sql.code'))
end function

public function string of_get_sql_errortext ();return pu_error.of_get_value('sql.sqlerrortext')
end function

public function string of_get_sql_syntax ();return pu_error.of_get_value('sql.sqlsyntax')
end function

on u_exf_re_database.create
call super::create
end on

on u_exf_re_database.destroy
call super::destroy
end on

