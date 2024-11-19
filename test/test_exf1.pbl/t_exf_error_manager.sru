forward
global type t_exf_error_manager from u_tst_testcase
end type
end forward

global type t_exf_error_manager from u_tst_testcase
event te_stacktrace ( )
event te_memory_leak_finder ( )
end type
global t_exf_error_manager t_exf_error_manager

type prototypes

end prototypes

type variables


end variables

event te_stacktrace();string ls_stacktrace

u_exf_error_manager lu_em
lu_em = create u_exf_error_manager

ls_stacktrace = lu_em.of_get_stacktrace()
pu_context.event ue_log(ls_stacktrace)
pu_context.of_assert(len(ls_stacktrace) > 0, 'There was an error while receiving the stacktrace')
end event

event te_memory_leak_finder();//Zweck		Liest in einem Loop den Callstack mehrfach aus und untersucht währenddessen den RAM Verbrauch
//Erstellt	2022-07-18 Simon Reichenbach

u_tst_systeminfo lu_system
ulong lul_ram_begin
long ll_i
string ls_stacktrace 
u_exf_error_manager lu_em
constant long LCL_MAX_GROWTH = 128 //=128 kB
lu_system = create u_tst_systeminfo
lul_ram_begin = lu_system.of_get_ram_usage()

// warm up cache
for ll_i = 1 to 100
	lu_em = create u_exf_error_manager
	ls_stacktrace = lu_em.of_get_stacktrace()
	destroy(lu_em)
	yield()
	garbagecollect()
	
next

// run the actual measurement
for ll_i = 1 to 1000
	lu_em = create u_exf_error_manager
	
	ls_stacktrace = lu_em.of_get_stacktrace()
	
	destroy(lu_em)
	if mod(ll_i, 10) = 0 then
		pu_context.event ue_log(right(space(4) + string(ll_i), 4) &
			+ ' RAM usage: ' + right(space(15) + string(lu_system.of_get_ram_usage()), 15) + 'B')
	end if
	
	yield()
	garbagecollect()
next

sleep(1)
pu_context.event ue_log('RAM Usage grew ' + string((longlong(lu_system.of_get_ram_usage()) - lul_ram_begin) / 1024) + 'kB')
pu_context.event ue_log('Start RAM: ' + string(lul_ram_begin / 1024) + 'kB' + ' Stop RAM: ' + string(lu_system.of_get_ram_usage() / 1024) + 'kB')

pu_context.of_assert(longlong(lu_system.of_get_ram_usage()) - lul_ram_begin < LCL_MAX_GROWTH * 1024, 'Der Speicherverbrauch ist mehr als ' + string(LCL_MAX_GROWTH)  + 'kB gewachsen')
end event

on t_exf_error_manager.create
call super::create
end on

on t_exf_error_manager.destroy
call super::destroy
end on

