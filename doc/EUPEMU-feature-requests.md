# EUPEMU Feature Requests

## 1. Tick Count Memory-Mapped I/O

Expose the emulator's internal tick counter as a readable MMIO region so programs can access it directly.

**Proposed address:** `0x10-0x13` (4 bytes, little-endian 32-bit unsigned)

**Behavior:**
- Reading any byte in 0x10-0x13 returns the corresponding byte of the current tick count
- 0x10 = low byte, 0x13 = high byte
- Read-only; writes are ignored
- Value matches the "Tick Count" shown in the debugger header

**sys.asm addition:**
```
A 0x010
V TickCount    # 32-bit tick counter (read-only, little-endian)
a 4
```

**Use case:** Programs can measure elapsed time, profile code sections, calibrate sleep loops, and do timing-sensitive operations without needing human-readable screen output.

## 2. Screenshot Trigger Memory-Mapped I/O

Writing to a trigger address causes the emulator to save the current terminal display area (rows 7-32) as a PNG screenshot.

**Proposed address:** `0x14` (1 byte, write-only trigger)

**Behavior:**
- Writing any non-zero value to 0x14 triggers a screenshot
- The emulator saves the current terminal area (rows 7-32, 80 columns) as a PNG
- File is saved to the same directory as the ROM file, named `{romname}_screenshot_{tickcount}.png`
- The byte resets to 0x00 after the screenshot is taken
- Writing 0x00 is a no-op

**sys.asm addition:**
```
V ScreenshotTrigger  # Write non-zero to capture terminal as PNG
a 1
```

**Use case:** Automated testing, documentation, capturing final animation frames, CI/CD visual regression testing. A program can draw its output, then trigger a screenshot at exactly the right moment without human interaction.

**Example usage in assembly:**
```
# After drawing is complete:
LDR ScreenshotTrigger
LAO                    # A = 1
SIA                    # trigger screenshot
```

## Current MMIO Map (with proposed additions)

| Address     | Name              | R/W | Description                          |
|-------------|-------------------|-----|--------------------------------------|
| 0x00-0x05   | RTCDate           | R   | Date string YYMMDD                   |
| 0x06        | RTCTrigger        | W   | 1=local, 2=GMT                       |
| 0x07-0x0D   | RTCTime           | R   | Time string HHMMSS\0                 |
| 0x0E-0x0F   | RTCmSec           | R   | Milliseconds (16-bit)                |
| **0x10-0x13** | **TickCount**   | **R** | **Tick counter (32-bit LE)**       |
| **0x14**    | **ScreenshotTrigger** | **W** | **Write non-zero to save PNG** |
| 0x15-0x1F   | *(reserved)*      | -   | Available for future MMIO            |
| 0x20        | PRNSeed           | W   | Write to reseed RNG from clock       |
| 0x21        | PRNRange          | W   | Write max value for next random      |
| 0x22        | PRNValue          | R   | Read random result                   |
| 0x23-0xFF   | *(reserved)*      | -   | Available for future MMIO            |
| 0x100+      | General RAM       | R/W | Variables and stack                  |
