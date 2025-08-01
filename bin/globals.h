using int8_t = __INT8_TYPE__;
using int16_t = __INT16_TYPE__;
using int32_t = __INT32_TYPE__;
using int64_t = __INT64_TYPE__;
using intptr_t = __INTPTR_TYPE__;

using uint8_t = __UINT8_TYPE__;
using uint16_t = __UINT16_TYPE__;
using uint32_t = __UINT32_TYPE__;
using uint64_t = __UINT64_TYPE__;
using uintptr_t = __UINTPTR_TYPE__;

using size_t = __SIZE_TYPE__;

using va_list = __builtin_va_list;
#define va_start(ap, last) __builtin_va_start(ap, last)
#define va_end(ap) __builtin_va_end(ap)
#define va_copy(to, from) __builtin_va_copy(to, from)
#define va_arg(to, type) __builtin_va_arg(to, type)

#define __dead2 __attribute__((__noreturn__))
#define __deprecated __attribute__((__deprecated__))
#define __packed __attribute__((__packed__))
#define __used __attribute__((__used__))
#define __unused __attribute__((__unused__))
#define __maybe_unused __attribute__((__unused__))
#define __aligned(x) __attribute__((__aligned__(x)))
#define __section(x) __attribute__((__section__(x)))
#define __fallthrough __attribute__((__fallthrough__))
#define __noinline __attribute__((__noinline__))
#define __no_pauth __attribute__((target("branch-protection=none")))

#define __printflike(fmtarg, firstvararg) \
    __attribute__((__format__(__printf__, fmtarg, firstvararg)))

#define __weak_reference(sym, alias) \
    __asm__(".weak alias");          \
    __asm__(".equ alias, sym")

#define __STRING(x) #x
#define __XSTRING(x) __STRING(x)

#define __predict_true(exp) (exp)
#define __predict_false(exp) (exp)