forward
global type w_exf_send_form from window
end type
type st_description_help from statictext within w_exf_send_form
end type
type cb_cancel from commandbutton within w_exf_send_form
end type
type cb_ok from commandbutton within w_exf_send_form
end type
type st_sender from statictext within w_exf_send_form
end type
type st_description from statictext within w_exf_send_form
end type
type mle_description from multilineedit within w_exf_send_form
end type
type sle_sender from singlelineedit within w_exf_send_form
end type
end forward

global type w_exf_send_form from window
boolean visible = false
integer width = 3387
integer height = 1764
boolean titlebar = true
string title = "Error description"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_description_help st_description_help
cb_cancel cb_cancel
cb_ok cb_ok
st_sender st_sender
st_description st_description
mle_description mle_description
sle_sender sle_sender
end type
global w_exf_send_form w_exf_send_form

type variables


end variables

forward prototypes
protected function boolean pf_check_fields ()
end prototypes

protected function boolean pf_check_fields ();//Zweck		Kontrolliert die 
//Return		true	Alle Felder wurden korrekt ausgefüllt
//				false	Einige Felder sind fehlerhaft ausgefüllt
//Erstellt	2022-05-16 Simon Reichenbach	Ticket 300165

boolean lbo_ret = true

constant long LCL_COLOR_ERROR = 8552425
constant long LCL_COLOR_NORMAL = 16777215

if len(sle_sender.text) > 0 then
	sle_sender.backcolor = LCL_COLOR_NORMAL
else
	sle_sender.backcolor = LCL_COLOR_ERROR
	lbo_ret = false
end if

if len(mle_description.text) > 0 then
	mle_description.backcolor = LCL_COLOR_NORMAL
else
	mle_description.backcolor = LCL_COLOR_ERROR
	lbo_ret = false
end if

return lbo_ret
end function

on w_exf_send_form.create
this.st_description_help=create st_description_help
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_sender=create st_sender
this.st_description=create st_description
this.mle_description=create mle_description
this.sle_sender=create sle_sender
this.Control[]={this.st_description_help,&
this.cb_cancel,&
this.cb_ok,&
this.st_sender,&
this.st_description,&
this.mle_description,&
this.sle_sender}
end on

on w_exf_send_form.destroy
destroy(this.st_description_help)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_sender)
destroy(this.st_description)
destroy(this.mle_description)
destroy(this.sle_sender)
end on

event open;//Zweck		In diesem Fenster muss der User eine Fehlerbeschreibung eingeben
//				Dies wird benötigt, damit nicht Mails ohne Beschreibung in den Support gelangen
//Erstellt	2022-05-17 Simon Reichenbach, Ticket 300165

sle_sender.text = gu_e.of_get_app_adapter().of_get_current_username()

this.title = gu_e.of_get_app_adapter().of_get_text(18412, 'Error description')
st_description_help.text = gu_e.of_get_app_adapter().of_get_text(18432, 'Please describe in short, reproducible steps what happened.')
st_description.text = gu_e.of_get_app_adapter().of_get_text(11000789, 'Description')
st_sender.text = gu_e.of_get_app_adapter().of_get_text(12205, 'Sender')
cb_ok.text = gu_e.of_get_app_adapter().of_get_text(10156, 'OK')
cb_cancel.text = gu_e.of_get_app_adapter().of_get_text(14947, 'Cancel')

gu_e.of_get_app_adapter().of_spawn_window(this)

end event

type st_description_help from statictext within w_exf_send_form
integer x = 18
integer y = 256
integer width = 549
integer height = 800
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 67108864
string text = "Please describe in short, reproducible steps what happened."
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_exf_send_form
integer x = 1061
integer y = 1552
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_ok from commandbutton within w_exf_send_form
integer x = 585
integer y = 1552
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;//2022-05-17 Simon Reichenbach, Ticket 300165: Mailversand neu über Meldeformular-Fenster

string ls_ret

if not pf_check_fields() then
	return 0
end if

ls_ret = st_sender.text + ': ' + sle_sender.text + '~r~n' &
		 + st_description.text + ':~r~n' &
		 + mle_description.text

closewithreturn(parent, ls_ret)
end event

type st_sender from statictext within w_exf_send_form
integer x = 18
integer y = 32
integer width = 549
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sender"
boolean focusrectangle = false
end type

type st_description from statictext within w_exf_send_form
integer x = 18
integer y = 176
integer width = 549
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Description"
boolean focusrectangle = false
end type

type mle_description from multilineedit within w_exf_send_form
integer x = 585
integer y = 176
integer width = 2761
integer height = 1344
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

event modified;pf_check_fields()
end event

type sle_sender from singlelineedit within w_exf_send_form
integer x = 585
integer y = 32
integer width = 1006
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;pf_check_fields()
end event

