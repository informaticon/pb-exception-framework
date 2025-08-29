forward
global type exf1_u_exf_ex_webrequest from u_exf_ex
end type
end forward

global type exf1_u_exf_ex_webrequest from u_exf_ex
end type
global exf1_u_exf_ex_webrequest exf1_u_exf_ex_webrequest

type variables

end variables

forward prototypes
public function long of_get_errorcode ()
public function u_exf_ex_webrequest of_set_errorcode (long al_errorcode)
end prototypes

public function long of_get_errorcode ();//2022-06-07 Martin Abplanalp, Ticket 300227

return long(pu_error.of_get_value('webrequest.errorcode'))
end function

public function u_exf_ex_webrequest of_set_errorcode (long al_errorcode);//2022-06-07 Martin Abplanalp, Ticket 300227

pu_error.of_push('webrequest.errorcode', al_errorcode)
return this
end function

on exf1_u_exf_ex_webrequest.create
call super::create
end on

on exf1_u_exf_ex_webrequest.destroy
call super::destroy
end on

