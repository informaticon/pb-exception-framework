#pragma once
#define WIN32_LEAN_AND_MEAN
#define _CRT_SECURE_NO_WARNINGS

#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <Shlwapi.h>
#include <malloc.h>

typedef struct {
	// 0x0004	*this
	// 0X000c   dbgthis
	// 0X00c6	curr obj group (used for shared variable and scope resolution for dynamic call)
	// 0X00d2	current object (_This)  pb_object*
	// 0x011e	heap ptr
	// 0x015c	stack position
	// 0x0154	stack pointer / evaled_arglist
	// 0x0158	something else stack related?
	// 0x0160	related to exception rethrow/cleaned-up ?
	// 0x0164 VALUE : _CALLED_RETURN_VALUE
	// 0x016c   routine level
	// 0x0200	local variables
	// 0x0204	something like available values slots in stack pointer ?
	// 0x024c	thrown_exception
}vm_state; //alias for POB_THIS

#pragma pack(1)

enum pbvalue_type
{
	pbvalue_notype = 0,
	pbvalue_int,
	pbvalue_long,
	pbvalue_real,
	pbvalue_double,
	pbvalue_dec,
	pbvalue_string,
	pbvalue_boolean,
	pbvalue_any,
	pbvalue_uint,
	pbvalue_ulong,
	pbvalue_blob,
	pbvalue_date,
	pbvalue_time,
	pbvalue_datetime,
	pbvalue_dummy1,
	pbvalue_dummy2,
	pbvalue_dummy3,
	pbvalue_char,
	pbvalue_dummy4,
	pbvalue_longlong,
	pbvalue_byte
};

typedef struct {
	PVOID value;
	short flags;
	/* known flags
		0x0001	is null
		0x0004	autoinstantiate
		0x0040	system type
		0x0100	instance?
		0x0200	shared?
		0x0400	2 byte
		0x0800	not valid?
		0x2000	is array;
	*/
	short type;
}value;

typedef struct {
	DWORD len;
	char data[1];
}blob;


#define IS_NULL 1
#define IS_ARRAY 0x2000

// variable?
typedef struct {
	DWORD flag; // 0 = immediate value / local variable, 1 = object field, 2 = object array element?
	short noidea; // -1??
	short type; 
	short flags; 
	value *value; // +0x0ah
	DWORD parent; // +0x0eh
	DWORD noidea3;
	DWORD item;
}lvalue;

// reference to variable?
typedef struct {
	lvalue *ptr;
	short isnull;
}lvalue_ref;

typedef struct{
    void* f1;
    short group_id;//+4 (x64 +8)
    short class_id;//+6 (x64 +10)
    short routine_id;
    short f2;
	short f3;
	short f4;
	short f5;
	short f6;
	short f7;
	short f8;
	short f9;
	void * f10;
	void * f12;
	void * f13;
    short caller_line_no;//+38 (x64 +54)
	short f16;
	short f17;
	short f18;
	short f19;
	short f20;
	short f21;
	void * f22;
	short f24;
	short f25;
	short f26;
	short f27;
	short f28;
}stack_info;

typedef struct{
	long f1;
	short f2;
	long current_line_no;
	//and other bytes up to a length of 0x22h bytes (sizeof allocated struct)
}current_stack_info;

typedef struct{ // don't need to know what's actually in this struct...
}group_data;

typedef struct{ // don't need to know what's actually in this struct...
	//group_data* groupe
}class_data;

typedef struct {
} pb_array;

typedef struct {
} pb_class;

typedef struct {
} pb_object;

typedef bool __stdcall shlist_callback(stack_info *, void *);

// PBVM imports
wchar_t * __stdcall ob_class_name_not_indirect(vm_state *, int);
wchar_t * __stdcall ob_event_module_name(vm_state *, group_data *, class_data *, short);
class_data * __stdcall ob_get_class_entry(vm_state *, group_data **, short);
wchar_t * __stdcall ob_get_group_name(vm_state *, short);
group_data * __stdcall ob_group_data_srch(vm_state *, short);
current_stack_info* __stdcall ob_get_current_stack_location(vm_state *);
pb_array * __stdcall ot_array_create_unbounded(vm_state *, int, int);
value * __stdcall ot_array_index(vm_state *, pb_array *, int);
void __stdcall ot_assign_ref_array(vm_state *, lvalue *, pb_array*, short, short);
void __stdcall ot_free_val_ptr(vm_state *, value *);
lvalue_ref * __stdcall ot_get_next_lvalue_arg(vm_state *, PVOID *);
void __stdcall ot_set_return_val(vm_state *, value *);
void * __stdcall pbstg_alc(vm_state *, int, PVOID);
void __stdcall pbstg_fee(vm_state*, void*);
bool __stdcall shlist_traversal(void *, void *, shlist_callback);


#if _WIN64
#define GET_HEAP(x) (*(PVOID *)(((char *)x) + 0x1d2))
#define GET_STACKLIST(x) (void*)(*(PVOID *)(((char *)x) + 0x15e))
#else
#define GET_HEAP(x) (*(PVOID *)(((char *)x) + 0x11e))
#define GET_STACKLIST(x) (void*)(*(PVOID *)(((char *)x) + 0xda))
#define GET_THROW(x) (((pb_class**)x)[147])
#define GET_EVALEDARGLIST(x) (value*)(*(DWORD *)(((char *)x) + 0x0154))
#define GET_THROWNEXCEPTION(x) (*(DWORD *)(((char *)x) + 0x024c))
#define GET_CALLEDRETURNVALUE(x) (value*)((DWORD *)(((char *)x) + 0x0164))
#endif

value * get_lvalue(vm_state *vm, lvalue_ref *value_ref);
void Throw_Exception(vm_state *vm, wchar_t *text, ...);
void Install_Crash_Hook();
void Uninstall_Crash_Hook();

extern vm_state *last_vm;