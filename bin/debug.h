#pragma once

#include "globals.h"

namespace blaze
{
    int printf(const char *fmt, ...) __printflike(1, 2);
    int vprintf(const char *fmt, va_list args);

    /*
    int snprintf(char *s, size_t n, const char *fmt, ...) __printflike(3, 4);
    int vsnprintf(char *s, size_t n, const char *fmt, va_list args);
    */
} // namespace blaze