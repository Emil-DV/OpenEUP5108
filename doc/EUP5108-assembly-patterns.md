# EUP5108 Assembly Patterns

Verified conventions and techniques for writing EUP5108 assembly,
including the T register corruption behavior and workarounds.

## T Register Corruption

The T register is corrupted by ALU-based increment/decrement and pointer operations.
The bit-serial ALU uses T as part of its carry/shift path for these operations.

**Operations that CORRUPT T:**
- POE, PDO (16-bit SP + immediate addition)
- IND, DED (16-bit DR increment/decrement)
- INA, INB, DEA, DEB (8-bit inc/dec, sets T = pre-operation source value)

**Operations that PRESERVE T:**
- LDR, LAM, LBM, LTM, LAE, LBE, LTE (data loads)
- SIA, SIB, SIT, SCA, SCB, SCR, SCD (stores/pushes)
- DES, INS (stack pointer system ops - NOT ALU-based)
- EAB, EBA, EAT, EBT (8-bit add)
- MAB, MBA (8-bit subtract)
- LRB, LDA, LBA, LAB, LAR, LAD, LBD, etc. (register moves)
- JLC, JLR, JLN, JPL (jumps)

**Why:** INC/DEC instructions use the ALU's serial adder which physically routes through
the T register. System ops (INS/DES) use dedicated SP hardware, not the ALU.

**Key rule:** Never rely on T being preserved across POE, IND, INA, INB, DEA, DEB, or DED.
Load T with LTM or LTE immediately before the instruction that needs it.

## Stack Model

- Stack grows downward. SP initialized to 0xFFFF on boot.
- Push is post-decrement: `*SP = val, SP--`. Value ends up at SP+1 after push.
- `POE N` gives `DR = SP + N`. POE 1 accesses the most recently pushed/reserved byte.
- `DES` decrements SP (reserves a byte at SP+1 after decrement).
- `INS` increments SP (pops, but does not read the value into any register).
- `SCA/SCB/SCR/SCD` store A/B/R/D to stack and decrement SP. They do NOT modify the source register or DR.

## Calling Convention (pointer params on stack)

- Push each 16-bit pointer with `SCR` then `SCD` (R first, D second).
- On the stack: D (MSB) is at the lower offset (closer to SP), R (LSB) at higher offset.
- `CAL` pushes a 2-byte return address.
- Inside a function, first param pushed (pA) is at SP+5, second (pB) at SP+3.
- After `N` DES locals, params shift by N (pA at SP+5+N, pB at SP+3+N).
- Caller cleans up with 4x `INS` after the call returns.

## Loading a pointer from the stack into DR

Standard pattern (uses IND, corrupts T):
```
POE offset      # DR = SP+offset → D byte (MSB)
LAM             # A = MSB
IND             # DR = SP+offset+1 → R byte (LSB). T CORRUPTED.
LBM             # B = LSB
LRB             # R = B
LDA             # D = A, DR = pointer
```

T-safe pattern (two POEs, no IND):
```
POE offset      # → D byte (MSB)
LAM             # A = MSB
POE offset+1    # → R byte (LSB). T still corrupted by POE but...
LBM             # B = LSB
LRB             # R = B
LDA             # D = A, DR = pointer
```
Neither pattern preserves T (POE corrupts it), but the two-POE version avoids IND.

## Setting T from a stack local (POE+LTM pattern)

`POE` corrupts T, but `LTM` immediately after sets T fresh from RAM[DR]:
```
POE offset      # T corrupted by POE
LTM             # T = RAM[SP+offset], set fresh
```
This is the only way to load T from a stack variable. T is valid from here until the next POE/IND/INA/INB/DEA/DEB.

## Storing a result through a pointer (XDS trick)

When A holds a result and you need to store it to `*pB` but DR doesn't point there:
```
SCA             # push result to stack
# Build DR = pB from locals (two POEs, offsets shifted +1 from SCA)
POE pBhi+1
LAM
POE pBlo+1      # (or pB1lo+1 for *pB[1])
LBM
LRB
LDA             # DR = pB
XDS             # swap DR ↔ SP. DR = old_SP, SP = pB.
IND             # DR = old_SP+1 → pushed result
LAM             # A = result
XDS             # swap back. DR = pB, SP = old_SP+1 (effectively popped).
SIA             # *pB = result
```
The XDS pair swaps DR and SP, lets you traverse the stack via IND, then swaps back. SP advances by the number of INDs, effectively popping items.

**WARNING:** XDS is NOT interrupt safe. Between the two XDS instructions, SP points
to the target address (pB), not the actual stack. If an IRQ fires during this window,
the IRQ handler will push registers to the wrong memory location, corrupting data.
Any function that uses the XDS trick must disable interrupts with `IQM` at the top
and re-enable with `IQU` before `RTL`.

## Flag preservation across instructions

- **Borrow flag** (from MAB/MBA): preserved through POE, SIA, SCA (NOT through IND which may set carry but borrow is separate).
- **Carry flag** (from EAT/EAB): preserved through SCA, SIA. NOT through POE or IND (which use the ALU adder and may set carry).
- Save carry/borrow immediately after the arithmetic op: `JLC`/`JLR`, `LAZ`/`LAO`, `SCA`.
