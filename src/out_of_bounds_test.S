#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # Save original trap vector
  csrr t5, mtvec
  
  # Register our trap handler
  la t0, trap_vector
  csrw mtvec, t0

  # Trigger the fault: Load from an address outside paddr_width_p
  li t1, 0x4000000000000000 
  lw t2, 0(t1)

  # If we reach here, hardware DID NOT trap (Failure)
  j fail

trap_vector:
  # Check cause (mcause == 5 for Load Access Fault)
  csrr t3, mcause
  li t4, 5
  bne t3, t4, fail

pass:
  csrw mtvec, t5
  RVTEST_PASS

fail:
  RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
