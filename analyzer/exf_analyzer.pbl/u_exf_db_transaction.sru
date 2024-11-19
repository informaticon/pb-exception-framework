forward
global type u_exf_db_transaction from transaction
end type
end forward

global type u_exf_db_transaction from transaction
end type
global u_exf_db_transaction u_exf_db_transaction

type variables
protected u_exf_log pu_log
boolean ibo_abort_dbactions // wenn true, werden SQL Updates/Inserts/Deletes nicht durchgeführt
end variables

forward prototypes
public subroutine of_set_logger (u_exf_log au_log)
public subroutine of_connect ()
public subroutine of_connect (string as_odbc_name)
end prototypes

public subroutine of_set_logger (u_exf_log au_log);pu_log = au_log
end subroutine

public subroutine of_connect ();//Verbinden mit Dummy Datenbank. Ist notwendig für bestimmte Funktionen, wie das Ausführen von .Update()
this.dbms = 'ODBC'

string ls_values[]
string ls_helper_db
contextkeyword lcx_key
getcontextservice ('keyword', lcx_key)
lcx_key.getcontextkeywords ('temp', ls_values)
ls_helper_db = ls_values[1] + '\exf_helper.db'
if not fileexists(ls_helper_db) then
	filecopy(getcurrentdirectory() + '\helper.db', ls_helper_db)
end if

this.dbparm = "connectstring='driver=sql anywhere 16;databasefile=" + ls_helper_db + ";uid=org;pwd=sql;integrated=no;compress=no;idle=1440',CommitOnDisconnect='No',DisableBind=1"
connect using this;
end subroutine

public subroutine of_connect (string as_odbc_name);//Verbinden mit Dummy Datenbank. Ist notwendig für bestimmte Funktionen, wie das Ausführen von .Update()
this.dbms = 'ODBC'
//this.dbparm = "connectstring='driver=sql anywhere 16;dsn=" + as_odbc_name + ";compress=no;idle=1440',CommitOnDisconnect='No',DisableBind=1"
connect using this;

end subroutine

on u_exf_db_transaction.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_exf_db_transaction.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event dberror;
pu_log.of_push_dberror(code, sqlerrtext, sqlsyntax)

end event

event sqlpreview;
pu_log.of_push_sqlpreview(sqlfunc, sqlsyntax)
if ibo_abort_dbactions then
	return 1 //1 -- Stop
else
	return 0 //0 - Continue
end if

end event

event constructor;ibo_abort_dbactions = true
end event

