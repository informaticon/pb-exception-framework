#pragma once

#include "pbvm.hpp"

DWORD __declspec(dllexport) __stdcall get_stacktrace(vm_state *vm, DWORD arg_count);
