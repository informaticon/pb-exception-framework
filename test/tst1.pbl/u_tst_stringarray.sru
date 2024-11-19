forward
global type u_tst_stringarray from nonvisualobject
end type
end forward

global type u_tst_stringarray from nonvisualobject
end type
global u_tst_stringarray u_tst_stringarray

type variables
string is_data[]
end variables

forward prototypes
public function string of_get (long al_index)
public function long of_get_size ()
public subroutine of_set (long al_index, string as_new_value)
public function u_tst_stringarray of_push_back (string as_value)
end prototypes

public function string of_get (long al_index);return is_data[al_index]
end function

public function long of_get_size ();return upperbound(is_data)
end function

public subroutine of_set (long al_index, string as_new_value);is_data[al_index] = as_new_value
end subroutine

public function u_tst_stringarray of_push_back (string as_value);is_data[upperbound(is_data) + 1] = as_value
return this
end function

on u_tst_stringarray.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_tst_stringarray.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

