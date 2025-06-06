forward
global type w_demo_main from window
end type
type cb_throw from commandbutton within w_demo_main
end type
end forward

global type w_demo_main from window
integer width = 1015
integer height = 404
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_throw cb_throw
end type
global w_demo_main w_demo_main

forward prototypes
public function string of_trywat (integer ai_parm1, string as_parm2)
end prototypes

public function string of_trywat (integer ai_parm1, string as_parm2);
try
	throw(gu_e.iu_as.of_ex(gu_e.of_new_error() &
		.of_push(populateerror(0, 'myerror')) &
		.of_push('somethin', 'Hello World') &
		.of_push('ai_parm1', ai_parm1) &
		.of_push('as_parm2', as_parm2) &	
	))
catch (u_exf_ex lu_e)
	throw(gu_e.iu_as.of_re_invalidstate(gu_e.of_new_error() &
		.of_push(populateerror(0, 'Wrapping error')) &
		.of_set_nested_error(lu_e) &
	))
end try
	
return 'It works'
end function

on w_demo_main.create
this.cb_throw=create cb_throw
this.Control[]={this.cb_throw}
end on

on w_demo_main.destroy
destroy(this.cb_throw)
end on

type cb_throw from commandbutton within w_demo_main
integer x = 219
integer y = 128
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Throw"
end type

event clicked;try
	of_trywat(1, 'ABC')
catch(runtimeerror lu_e)
	gu_e.of_display(lu_e)
end try
end event

