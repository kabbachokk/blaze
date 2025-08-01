#include "config.h"
#include "debug.h"
#include "globals.h"
#include "main_impl.h"

namespace blaze
{
    constexpr unsigned int FDT_MAGIC = (unsigned int)0xd00dfeed;
    struct fdt_header
    {
        uint32_t magic;             /* magic word FDT_MAGIC */
        uint32_t totalsize;         /* total size of DTB */
        uint32_t off_dt_struct;     /* offset to structure block */
        uint32_t off_dt_strings;    /* offset to strings block */
        uint32_t off_mem_rsvmap;    /* offset to memory reserve map */
        uint32_t version;           /* format version */
        uint32_t last_comp_version; /* last compatible version */
        uint32_t boot_cpuid_phys;   /* physical ID of boot CPU */
        uint32_t size_dt_strings;   /* size of strings block */
        uint32_t size_dt_struct;    /* size of structure block */
    };

    static uint32_t be32toh(const uint8_t *p)
    {
        return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) | ((uint32_t)p[2] << 8) | p[3];
    }

    void parse_dtb_header(const void *dtb)
    {
        const uint8_t *p = (const uint8_t *)dtb;

        uint32_t magic = be32toh(p + 0);
        if (magic != FDT_MAGIC)
        {
            printf("Invalid DTB magic: 0x%08x\n", magic);
            return;
        }

        uint32_t totalsize = be32toh(p + 4);
        uint32_t off_dt_struct = be32toh(p + 8);
        uint32_t off_dt_strings = be32toh(p + 12);
        uint32_t off_mem_rsvmap = be32toh(p + 16);
        uint32_t version = be32toh(p + 20);
        uint32_t last_comp_ver = be32toh(p + 24);
        uint32_t boot_cpuid_phys = be32toh(p + 28);
        uint32_t size_dt_strings = be32toh(p + 32);
        uint32_t size_dt_struct = be32toh(p + 36);

        printf("dtb header:\n");
        printf("    magic:          0x%08x\n", magic);
        printf("    total size:     %u bytes\n", totalsize);
        printf("    offset struct:  %u\n", off_dt_struct);
        printf("    offset strings: %u\n", off_dt_strings);
        printf("    offset memrsv:  %u\n", off_mem_rsvmap);
        printf("    version:        %u\n", version);
        printf("    last compat:    %u\n", last_comp_ver);
        printf("    boot cpu id:    %u\n", boot_cpuid_phys);
        printf("    strings size:   %u\n", size_dt_strings);
        printf("    struct size:    %u\n", size_dt_struct);
    }

    void main(void *arg)
    {
        printf("git commit (short): %s\n", GIT_COMMIT);
        parse_dtb_header(arg);

        while (true)
            ;
    };
} // namespace blaze
