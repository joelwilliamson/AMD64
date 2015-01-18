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

void cpuid(uint32_t func, uint32_t& a, uint32_t& b, uint32_t& c, uint32_t& d)
{
  asm volatile ("cpuid"
		: "=a" (a), "=b" (b), "=c" (c), "=d" (d)
		: "a" (func));
}

const char * cpu_name(char name[13]) {
  uint32_t first,mid,last,dump;
  uint32_t func = 0;

  cpuid(0,dump,first,last,mid);
  
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

uint32_t largest_standard_function() {
  uint32_t largest, dump;
  cpuid(0,largest,dump,dump,dump);
  return largest;
}
