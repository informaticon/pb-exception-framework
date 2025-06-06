forward
global type w_exf_inputbox from window
end type
type cb_cancel from commandbutton within w_exf_inputbox
end type
type sle_input from singlelineedit within w_exf_inputbox
end type
type cb_ok from commandbutton within w_exf_inputbox
end type
end forward

global type w_exf_inputbox from window
integer width = 2345
integer height = 344
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
sle_input sle_input
cb_ok cb_ok
end type
global w_exf_inputbox w_exf_inputbox

type variables

end variables

on w_exf_inputbox.create
this.cb_cancel=create cb_cancel
this.sle_input=create sle_input
this.cb_ok=create cb_ok
this.Control[]={this.cb_cancel,&
this.sle_input,&
this.cb_ok}
end on

on w_exf_inputbox.destroy
destroy(this.cb_cancel)
destroy(this.sle_input)
destroy(this.cb_ok)
end on

event open;string ls_data
ls_data = message.stringparm

if pos(ls_data, ';') > 0 then
	sle_input.text = mid(ls_data, pos(ls_data, ';') + 1)
	ls_data = left(ls_data, pos(ls_data, ';') - 1)
end if

this.title = ls_data
end event

type cb_cancel from commandbutton within w_exf_inputbox
integer x = 1097
integer y = 160
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type sle_input from singlelineedit within w_exf_inputbox
integer x = 37
integer y = 32
integer width = 2267
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_ok from commandbutton within w_exf_inputbox
integer x = 658
integer y = 160
integer width = 402
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;closewithreturn(parent, sle_input.text)
end event


