# MIPS Memory Mapped I/O (MMIO) CPU

This is an extension of my pipelined CPU found at https://github.com/Charblez/MIPS-Pipelined-CPU

## Core changes
- Memory modules no longer nested within pipeline stages
- Memory ports created in CPU module for external memory access
- Implementation of a basic memory arbiter for CPU memory access
- Memory address translations to allow direct input of MARS assembled MIPS code

## Future Intentions
- Use the external memory interface to control a vector coprocessor via MMIO'
- Poll memory to check when coprocessor data has been computed and continue CPU bound computation
