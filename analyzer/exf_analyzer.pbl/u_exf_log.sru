forward
global type u_exf_log from datawindow
end type
end forward

global type u_exf_log from datawindow
integer width = 2688
integer height = 824
string title = "none"
string dataobject = "d_exf_log"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type
global u_exf_log u_exf_log

forward prototypes
protected function long pf_push (string as_type)
public function long of_push_dberror (long al_sqldbcode, string as_sqlerrtext, string as_sqlsyntax, dwbuffer adwb_dwbuffer, long al_row)
public function long of_push_dberror (long al_sqldbcode, string as_sqlerrtext, string as_sqlsyntax)
public function long of_push_sqlpreview (sqlpreviewfunction a_request, sqlpreviewtype a_type, string as_sqlsyntax, dwbuffer adwb_buffer, long al_row)
public function long of_push_sqlpreview (sqlfunction a_function, string as_sqlsyntax)
public subroutine of_push_sqlselect (string as_select)
public subroutine of_push_dw_syntax (string as_syntax)
end prototypes

protected function long pf_push (string as_type);long ll_row

ll_row = this.insertrow(1)
this.setitem(ll_row, 'dt_timestamp', datetime(today(), now()))
this.setitem(ll_row, 's_type', as_type)

return ll_row
end function

public function long of_push_dberror (long al_sqldbcode, string as_sqlerrtext, string as_sqlsyntax, dwbuffer adwb_dwbuffer, long al_row);long ll_row

ll_row = pf_push('dberror')

this.setitem(ll_row, 'l_sqldbcode', al_sqldbcode)
this.setitem(ll_row, 's_sqlerrtext', as_sqlerrtext)
this.setitem(ll_row, 's_data', as_sqlsyntax)
this.setitem(ll_row, 'l_row', al_row)

choose case adwb_dwbuffer
	case primary!
		this.setitem(ll_row, 's_dwbuffer', 'primary!')
	case delete!
		this.setitem(ll_row, 's_dwbuffer', 'delete!')
	case filter!
		this.setitem(ll_row, 's_dwbuffer', 'filter!')
end choose
return ll_row
end function

public function long of_push_dberror (long al_sqldbcode, string as_sqlerrtext, string as_sqlsyntax);long ll_row
ll_row = pf_push('dberror')

this.setitem(ll_row, 'l_sqldbcode', al_sqldbcode)
this.setitem(ll_row, 's_sqlerrtext', as_sqlerrtext)
this.setitem(ll_row, 's_data', as_sqlsyntax)

return ll_row
end function

public function long of_push_sqlpreview (sqlpreviewfunction a_request, sqlpreviewtype a_type, string as_sqlsyntax, dwbuffer adwb_buffer, long al_row);long ll_row

ll_row = pf_push('sqlpreview')

this.setitem(ll_row, 's_data', as_sqlsyntax)
this.setitem(ll_row, 'l_row', al_row)

choose case a_request
	case previewfunctionretrieve!
		this.setitem(ll_row, 's_sqlfunction', 'previewfunctionretrieve!')
	case previewfunctionreselectrow!
		this.setitem(ll_row, 's_sqlfunction', 'previewfunctionreselectrow!')
	case previewfunctionupdate!
		this.setitem(ll_row, 's_sqlfunction', 'previewfunctionupdate!')
end choose

choose case a_type
	case previewselect!
		this.setitem(ll_row, 's_previewtype', 'previewselect!')
	case previewinsert!
		this.setitem(ll_row, 's_previewtype', 'previewinsert!')
	case previewdelete!
		this.setitem(ll_row, 's_previewtype', 'previewdelete!')
	case previewupdate!
		this.setitem(ll_row, 's_previewtype', 'previewupdate!')
end choose

choose case adwb_buffer
	case primary!
		this.setitem(ll_row, 's_dwbuffer', 'primary!')
	case delete!
		this.setitem(ll_row, 's_dwbuffer', 'delete!')
	case filter!
		this.setitem(ll_row, 's_dwbuffer', 'filter!')
end choose
return ll_row
end function

public function long of_push_sqlpreview (sqlfunction a_function, string as_sqlsyntax);long ll_row

ll_row = pf_push('sqlpreview')

this.setitem(ll_row, 's_data', as_sqlsyntax)
choose case a_function
	case sqldbinsert!
		this.setitem(ll_row, 's_sqlfunction', 'sqldbinsert!')
	case sqldbupdate!
		this.setitem(ll_row, 's_sqlfunction', 'sqldbupdate!')
	case sqldbdelete!
		this.setitem(ll_row, 's_sqlfunction', 'sqldbdelete!')
	case sqldbselect!
		this.setitem(ll_row, 's_sqlfunction', 'sqldbselect!')
	case sqldbprocedure!
		this.setitem(ll_row, 's_sqlfunction', 'sqldbprocedure!')
	case sqldbrpc!
		this.setitem(ll_row, 's_sqlfunction', 'sqldbrpc!')
	case sqldbothers!
		this.setitem(ll_row, 's_sqlfunction', 'sqldbothers!')
end choose

return ll_row
end function

public subroutine of_push_sqlselect (string as_select);long ll_row
ll_row = this.pf_push('sqlselect')

this.setitem(ll_row, 's_data', as_select)
end subroutine

public subroutine of_push_dw_syntax (string as_syntax);long ll_row
ll_row = this.pf_push('dwsyntax')

this.setitem(ll_row, 's_data', as_syntax)
end subroutine

on u_exf_log.create
end on

on u_exf_log.destroy
end on


