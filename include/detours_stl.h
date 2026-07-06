#pragma once

#include <detours/detours.h>

namespace stl {
    template <class Func>
    uintptr_t write_prologue_hook(uintptr_t a_src, Func* a_dest) {
        DetourTransactionBegin();
        DetourUpdateThread(GetCurrentThread());
        DetourAttach(&(PVOID&)a_src, a_dest);
        DetourTransactionCommit();
        return a_src;
    }
}
