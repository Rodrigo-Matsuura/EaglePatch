#pragma section(".CRT$XIA", read)
#pragma section(".CRT$XIZ", read)
#pragma section(".CRT$XCA", read)
#pragma section(".CRT$XCZ", read)
#pragma section(".CRT$XTA", read)
#pragma section(".CRT$XTZ", read)

extern "C" {
    __declspec(allocate(".CRT$XIA")) void* __xi_a = nullptr;
    __declspec(allocate(".CRT$XIZ")) void* __xi_z = nullptr;
    __declspec(allocate(".CRT$XCA")) void* __xc_a = nullptr;
    __declspec(allocate(".CRT$XCZ")) void* __xc_z = nullptr;
    __declspec(allocate(".CRT$XTA")) void* __xt_a = nullptr;
    __declspec(allocate(".CRT$XTZ")) void* __xt_z = nullptr;
}

#include <stdlib.h>

void* operator new(size_t size) {
    return malloc(size);
}

void operator delete(void* ptr) noexcept {
    free(ptr);
}

void* operator new[](size_t size) {
    return malloc(size);
}

void operator delete[](void* ptr) noexcept {
    free(ptr);
}

void operator delete(void* ptr, size_t size) noexcept {
    free(ptr);
}

void operator delete[](void* ptr, size_t size) noexcept {
    free(ptr);
}
