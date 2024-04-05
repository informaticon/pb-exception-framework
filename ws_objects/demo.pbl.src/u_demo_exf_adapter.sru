$PBExportHeader$u_demo_exf_adapter.sru
forward
global type u_demo_exf_adapter from u_exf_application_adapter
end type
end forward

global type u_demo_exf_adapter from u_exf_application_adapter
end type
global u_demo_exf_adapter u_demo_exf_adapter

type variables

end variables

forward prototypes
public function string of_get_text (long al_text_tbz, string as_text_fallback)
end prototypes

public function string of_get_text (long al_text_tbz, string as_text_fallback);
choose case al_text_tbz
	case 18687
		// Don't show upload message
		return ''
	case else
		return super::of_get_text(al_text_tbz, as_text_fallback)
end choose
end function

on u_demo_exf_adapter.create
call super::create
end on

on u_demo_exf_adapter.destroy
call super::destroy
end on

