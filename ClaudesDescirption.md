# OpenEUP5108 Architecture Description

This design is a **microprogrammed bit-serial architecture**.

The two key parts:

- **Microprogrammed control unit** — a ROM (the "control store") is indexed by opcode + step counter, and its output bits directly drive control signals (register clock enables, mux selects, etc.). Each ROM word is a *microinstruction*.
- **Bit-serial datapath** — the ALU operates on one bit per clock cycle, shifting data through rather than processing a full word in parallel.

Early computers like **EDSAC** and the **Manchester Baby** were bit-serial. The ROM-driven control style was popularized later as *microprogramming* (Wilkes, 1951). The combination keeps the design extremely simple — the ROM is the "brain" and you only need a 1-bit adder/logic cell instead of a wide parallel ALU.
