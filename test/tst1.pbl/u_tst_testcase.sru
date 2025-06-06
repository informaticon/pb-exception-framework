forward
global type u_tst_testcase from nonvisualobject
end type
end forward

global type u_tst_testcase from nonvisualobject
end type
global u_tst_testcase u_tst_testcase

type variables
protected u_tst_context pu_context
protected u_tst_stringarray pu_events
protected datawindow pdw_test
end variables

forward prototypes
public subroutine of_teardown ()
public function u_tst_stringarray of_setup (u_tst_context au_tst_context)
public function u_tst_stringarray of_get_events ()
end prototypes

public subroutine of_teardown ();setnull(pu_context)
end subroutine

public function u_tst_stringarray of_setup (u_tst_context au_tst_context);pu_context = au_tst_context

return pu_events


end function

public function u_tst_stringarray of_get_events ();return pu_events
end function

on u_tst_testcase.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_tst_testcase.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;long ll_i
classdefinition lcdf
scriptdefinition lsdf[]

lcdf = this.classdefinition
lsdf = lcdf.scriptlist
pu_events = create u_tst_stringarray

for ll_i = 1 to upperbound(lsdf)
	if lsdf[ll_i].kind = scriptevent! &
	and left(lsdf[ll_i].name, 3) = 'te_' then
		pu_events.of_push_back(lsdf[ll_i].name)
	end if
next

end event


