forward
global type w_tst_visual_container from window
end type
end forward

global type w_tst_visual_container from window
boolean visible = false
integer width = 4613
integer height = 1740
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
end type
global w_tst_visual_container w_tst_visual_container

type variables



protected dragobject pdrg_objs[]
end variables

forward prototypes
public function dragobject of_spawn_visual (string as_object_type)
public subroutine of_despawn_visual (dragobject ldrg_obj)
end prototypes

public function dragobject of_spawn_visual (string as_object_type);dragobject ldr_obj

if this.openuserobject(ldr_obj, as_object_type) > 0 then
	pdrg_objs[upperbound(pdrg_objs) + 1] = ldr_obj
	return ldr_obj
end if

throw(gu_e.iu_as.of_re(gu_e.of_new_error() &
	.of_push(populateerror(0, 'object could not be created')) &
	.of_push('as_object_type', as_object_type) &
))

end function

public subroutine of_despawn_visual (dragobject ldrg_obj);
if isvalid(ldrg_obj) then
	closeuserobject(ldrg_obj)
end if

end subroutine

on w_tst_visual_container.create
end on

on w_tst_visual_container.destroy
end on

event close;long ll_i

for ll_i = 1 to upperbound(pdrg_objs)
	if isvalid(pdrg_objs[ll_i]) then
		closeuserobject(pdrg_objs[ll_i])
	end if
next
end event


