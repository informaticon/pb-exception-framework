forward
global type u_exf_ex_pbni from u_exf_ex
end type
end forward

global type u_exf_ex_pbni from u_exf_ex
end type
global u_exf_ex_pbni u_exf_ex_pbni

type variables

end variables

forward prototypes
public function u_exf_error_data of_init (string as_message)
public function u_exf_ex of_nest (string as_type)
end prototypes

public function u_exf_error_data of_init (string as_message);//Zweck		Initialisiert das u_exf_ex_pbni Objekt
//				Wird vom PBNI Framework benötigt (dieses nutzt den Errormanager nicht)
//Argument	as_message	Fehlermeldung
//Return		u_exf_error_data	Eigenes errordata Objekt zum Hinzufügen weiterer Kontextdaten
//Erstellt	2022-08-16 Micha Wehrli

pu_error = create u_exf_error_data

pu_error.of_set_message(as_message)
pu_error.of_set_type('u_exf_ex_pbni')

gu_e.iu_as.event ue_register_error(pu_error)

return pu_error
end function

public function u_exf_ex of_nest (string as_type);//Zweck		Instanziert eine neue Exception und verpackt sich selbt in dieser.
//				Wird vom PBNI Framework benötigt (dieses nutzt den Errormanager nicht).
//Argument	as_type	Typ (Klassenname) der gewünschten Exception (z.B. 'u_exf_ex_io')
//Return		Instanz einer beliebigen Spezialisierung von u_exf_ex
//				NULL, falls as_type nicht existiert
//Erstellt	2023-05-10 Simon Reichenbach

u_exf_ex lu_e

try
	lu_e = create using as_type
catch (runtimeerror lr_r)
	setnull(lu_e)
	return lu_e
end try

lu_e.of_set_error(gu_e.of_new_error() &
	.of_set_message(pu_error.of_get_message()) &
	.of_set_nested_error(this) &
)

return lu_e


end function

on u_exf_ex_pbni.create
call super::create
end on

on u_exf_ex_pbni.destroy
call super::destroy
end on

event constructor;call super::constructor;// 2022-08-16 Micha Wehrli: Exception für PBNI Framework (lib.cpp.base.pbni-framework)
// Im Gegensatz zu anderen Exceptions gibt es im u_exf_error_creater bewusst keine korresponidierende
// creater Funktion, weil u_exf_ex_pbni darf nur aus einer PBNI Extension heraus instanziiert werden.
end event

