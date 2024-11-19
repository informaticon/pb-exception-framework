forward
global type u_tst_win32_api from nonvisualobject
end type
end forward

global type u_tst_win32_api from nonvisualobject
end type
global u_tst_win32_api u_tst_win32_api

type prototypes

protected function boolean pef_attach_console( &
	long al_procid &
) library 'kernel32.dll' alias for 'AttachConsole'

protected function long pef_get_std_handle( &
	long nstdhandle &
) library 'kernel32.dll' alias for 'GetStdHandle'

protected function int pef_free_console() library 'kernel32.dll' alias for 'FreeConsole'

protected function ulong pef_write_console( &
	long al_handle, &
	string ps_output, &
	long pl_numcharstowrite, &
	ref long pl_numcharswritten, &
	long reserved &
) library 'kernel32.dll' alias for 'WriteConsoleW'

protected subroutine pef_keybd_event( &
	int pi_bvk, &
	int pi_bscan, &
	int pi_dwflags, &
	int pi_dwextrainfo &
) library 'user32.dll' alias for 'keybd_event'

protected subroutine pef_exit_process( &
	ulong uexitcode &
) library 'kernel32.dll' alias for 'ExitProcess'

end prototypes

type variables
protected constant long PCL_ATTACH_PARENT_PROCESS = -1
protected constant long PCL_STD_OUTPUT_HANDLE = -11
protected constant long PCL_STD_ERROR_HANDLE = -12
protected constant long PCL_STD_INPUT_HANDLE = -10
protected long pl_hwnd

end variables

forward prototypes
public subroutine of_print_ln (string as_line)
public subroutine of_exit (unsignedlong aul_code)
public function boolean of_is_console_connected ()
end prototypes

public subroutine of_print_ln (string as_line);string s
long result

if handle(getapplication()) = 0 or isnull(pl_hwnd) then
	//TODO send to log
else
   s = as_line + '~r~n'
   pef_write_console(pl_hwnd, s, len(s), result, 0)
end if
end subroutine

public subroutine of_exit (unsignedlong aul_code);pef_exit_process(aul_code)
halt
end subroutine

public function boolean of_is_console_connected ();return not isnull(pl_hwnd)
end function

on u_tst_win32_api.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_tst_win32_api.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;setnull(pl_hwnd)
if handle(getapplication()) > 0 then
   if pef_attach_console(PCL_ATTACH_PARENT_PROCESS) then
      pl_hwnd = pef_get_std_handle(PCL_STD_OUTPUT_HANDLE)
   end if
end if

end event

event destructor;if of_is_console_connected() then
	pef_keybd_event(13, 1, 0, 0)
	pef_free_console()
end if

end event

