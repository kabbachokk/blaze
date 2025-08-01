#include "main_impl.h"

extern "C"
{
    /// @brief _main entry of kernel
    /// @param arg depends on platform (its's dtb on aarch64)
    void _main(void *arg)
    {
        blaze::main(arg);
        __builtin_unreachable();
    };
}
