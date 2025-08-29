forward
global type u_exf_re from runtimeerror
end type
end forward

global type u_exf_re from runtimeerror
string objectname = "exf1_u_exf_re"
string class = "exf1_u_exf_re"
string routinename = "create"
integer line = -1
end type
global u_exf_re u_exf_re

type variables
protected u_exf_error_data pu_error
end variables

forward prototypes
public function u_exf_error_data of_get_error ()
public subroutine of_set_error (u_exf_error_data au_error)
public function string getmessage ()
end prototypes

public function u_exf_error_data of_get_error ();//Zweck		Getter für Error-Daten
//				Das zurückgegebene u_exf_error_data-Objekt beinhaltet alle relevanten Daten zum RuntimeError
//Return		u_exf_error_data	
//Erstellt	2020-11-16 Simon Reichenbach

return pu_error
end function

public subroutine of_set_error (u_exf_error_data au_error);//Zweck		Setter für Error-Daten
//				Das u_exf_error_data-Objekt beinhaltet alle relevanten Daten zum RuntimeError
//Argument	au_error	u_exf_error_data-Instanz mit Daten zur Exception
//Erstellt	2020-11-16 Simon Reichenbach

pu_error = au_error
pu_error.of_set_type(classname(this))
end subroutine

public function string getmessage ();
if len(super::getmessage()) > 0 then
	return super::getmessage()
else
	return pu_error.of_get_message()
end if
end function

on u_exf_re.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_exf_re.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

