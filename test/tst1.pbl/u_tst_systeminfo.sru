forward
global type u_tst_systeminfo from nonvisualobject
end type
type st_process_memory_counters from structure within u_tst_systeminfo
end type
end forward

type st_process_memory_counters from structure
	unsignedlong		ul_struct_size		descriptor "comment" = "The size of the structure, in bytes."
	unsignedlong		ul_page_fault_count		descriptor "comment" = "The number of page faults."
	unsignedlong		ul_peak_working_set_size		descriptor "comment" = "The peak working set size, in bytes."
	unsignedlong		ul_working_set_size		descriptor "comment" = "The current working set size, in bytes."
	unsignedlong		ul_quota_peak_pagedp_usage		descriptor "comment" = "The peak paged pool usage, in bytes."
	unsignedlong		ul_quota_pagedp_usage		descriptor "comment" = "The current paged pool usage, in bytes."
	unsignedlong		ul_quota_peak_non_pagedp_usage		descriptor "comment" = "The peak nonpaged pool usage, in bytes."
	unsignedlong		ul_quota_non_pagedp_usage		descriptor "comment" = "The current nonpaged pool usage, in bytes."
	unsignedlong		ul_pagefile_usage		descriptor "comment" = "The Commit Charge value in bytes for this process. Commit Charge is the total amount of memory that the memory manager has committed for a running process."
	unsignedlong		ul_peak_pagefile_usage		descriptor "comment" = "The peak value in bytes of the Commit Charge during the lifetime of this process."
end type

global type u_tst_systeminfo from nonvisualobject
end type
global u_tst_systeminfo u_tst_systeminfo

type prototypes
protected function boolean pef_get_process_memory_info( &
	long al_h_process, &
	ref st_process_memory_counters ast_pmc, &
	ulong aul_pmc_size /*The size of the ast_pmc structure, in bytes.*/ &
) library 'psapi.dll' alias for 'GetProcessMemoryInfo'

protected function ulong pef_get_current_process_handle( &
) library 'kernel32.dll' alias for 'GetCurrentProcess'


end prototypes

type variables
private st_process_memory_counters l
st_process_memory_counters l1

end variables

forward prototypes
public function ulong of_get_ram_usage ()
end prototypes

public function ulong of_get_ram_usage ();st_process_memory_counters lst_pmc
constant ulong LCUL_PMC_LEN = 4 * 10

if not pef_get_process_memory_info(pef_get_current_process_handle(), lst_pmc, LCUL_PMC_LEN) then
	return 0
end if

return lst_pmc.ul_working_set_size
end function

on u_tst_systeminfo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_tst_systeminfo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on


