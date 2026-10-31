#pragma once

// MinGW compatibility shims for MSVC-specific constructs used by R3nzSkin.

#ifdef __GNUC__

// MSVC __try/__except (SEH) -> portable try/catch(...).
// __except(expression) ignores the expression and catches everything.
#define __try try
#define __except(...) catch (...)

// safebuffers is an MSVC-only attribute; make it a no-op.
#ifndef safebuffers
#define safebuffers
#endif

// MSVC CRT threading -> Win32 CreateThread.
#include <process.h>
#ifndef _beginthreadex
#define _beginthreadex(lpSecurity, dwStackSize, lpStartAddress, lpParameter, dwCreationFlags, lpThreadId) \
	CreateThread(lpSecurity, dwStackSize, reinterpret_cast<LPTHREAD_START_ROUTINE>(lpStartAddress), lpParameter, dwCreationFlags, lpThreadId)
#endif

#ifndef _beginthreadex_proc_type
#define _beginthreadex_proc_type unsigned(__stdcall*)(void*)
#endif

// MSVC pragma warnings are no-ops on GCC/Clang.
#ifndef __pragma
#define __pragma(x)
#endif

// Disable some noisy MSVC-only pragma warnings.
#pragma GCC diagnostic ignored "-Wattributes"

#endif // __GNUC__
