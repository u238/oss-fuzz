#include "ntop_includes.h"


void write_binary_file(const char * filename, const uint8_t * data, size_t size) {
    FILE *out = fopen(filename, "wb");
    const size_t wrote = fwrite(data, size, 1, out);
    fclose(out);
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
//    const char * filename = "/home/u238/tmpfs/test.bin";
    const char * filename = "/tmp/test.bin";

    write_binary_file(filename,
                      Data,
                      Size);

    Prefs *prefs = NULL;
    if((ntop = new(std::nothrow)  Ntop("argv[0]")) == NULL) _exit(0);
    ntop->getTrace()->set_trace_level(TRACE_LEVEL_ERROR);
    if((prefs = new(std::nothrow) Prefs(ntop)) == NULL)   _exit(0);

    prefs->loadFromFile(filename);
    delete(ntop);
    delete(prefs);
    return(0);
}
