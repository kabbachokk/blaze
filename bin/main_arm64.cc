#include "config.h"
#include "main_impl.h"

namespace blaze
{
    volatile unsigned int *const UART0DR = (unsigned int *)0x09000000;

    void print_uart(const char *s)
    {
        while (*s != '\0')
        {                                  /* Loop until end of string */
            *UART0DR = (unsigned int)(*s); /* Transmit char */
            s++;                           /* Next char */
        }
    }

    void main(int argc, char *argv[])
    {
        print_uart("Hello world!\ngit commit (short): ");
        print_uart(GIT_COMMIT);
        print_uart("\nargv[0]: ");
        print_uart(argv[0]);
    };
} // namespace blaze
