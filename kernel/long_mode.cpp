#include <stdint.h>

// If CPUID is enabled, the rFLAGS.ID bit can be flipped.
// So to check for CPUID, we try to flip rFLAGS.ID, read it, and
// see if the flip worked.
bool has_cpuid() {
  uint32_t retval;
  asm volatile (R"(
pushfl # Put the flags on the stack
popl %%eax # Get the flags in A
movl %%eax,%%ecx # Copy the flags to C
xorl 1<<21, %%ecx # Flip bit 21, rFLAGS.ID
pushl %%ecx
popfl # Attempt to reload flags
pushfl
popl %0 # Load rFLAGS into result register
xorl %%eax,%0 # Check if rFLAGS.ID stayed flipped )"
		: "=r" (retval)
		: /* No inputs */
		: "eax", "ecx");
  return !retval;
}

const char * cpu_name(char name[13]) {
  uint32_t first,mid,last;
  uint32_t func = 0;
  asm volatile ("cpuid"
		: "=b" (first), "=d" (mid), "=c" (last) 
		: "a" (func));
  for (int i = 0; i < 4; ++i) {
    name[i] = first & 0xFF;
    first >>= 8;
  }
  for (int i = 4; i < 8; ++i) {
    name[i] = mid & 0xFF;
    mid >>= 8;
  }
  for (int i = 8; i < 12; ++i) {
    name[i] = last & 0xFF;
    last >>= 8;
  }
  name[12]=0;
  return name;
}
