#include "stdio.h"
#ifdef __cplusplus
extern "C" {
#endif
extern char at_least_one_object_file;
extern void *kernel_scs_file_ht_new(const void *, int);
extern int kernel_scs_file_ht_get(void *, const char *, int *);
extern int  strcmp(const char*, const char*);
  typedef struct {
    char* dFileName;
  } lPkgFileInfoStruct;

  typedef struct {
    char* dFileName;
    char* dRealFileName;
    long dFileOffset;
    unsigned long dFileSize;
    int dFileModTime;
    unsigned int simFlag;
  } lFileInfoStruct;

static int lNumOfScsFiles;
  static lFileInfoStruct lFInfoArr[] = {
  {"synopsys_sim.setup_0", "/Disk2/eda/synopsys/2017-18/RHELx86/VCSMX_2017.12-1/bin/synopsys_sim.setup", 76645, 5174, 1516334711, 0},
  {"linux64/packages/synopsys/lib/64/NOVAS__.sim", "", 0, 76645, 0, 0},
  {"linux64/packages/synopsys/lib/64/NOVAS.sim", "", 81819, 50160, 0, 0},
