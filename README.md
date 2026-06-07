# Embedded RTOS

A work-in-progress bare-metal embedded RTOS project for embedded systems, initially targeting ARM Cortex-M microcontrollers.

This project is being built from the ground up to explore core RTOS concepts including thread management, context switching, scheduling, synchronization primitives, timing services, inter-thread communication, and real-time hardware demos.

The initial implementation targets the Nucleo-F411RE development board, which uses the STM32F411RE Cortex-M4 microcontroller.

---

## Current Milestone: GPIO Blink

The current verified milestone is bare-metal GPIO bring-up on the Nucleo-F411RE.

Implemented and verified:

- Custom startup path from reset to `main()`
- Linker script for STM32F411RE Flash/RAM layout
- GPIOA peripheral clock enable through RCC
- PA5 configured as a general-purpose output
- Onboard LD2 LED toggled using direct register access

![GPIO blink demo](docs/media/01_blink.gif)

---

## Current Project Layout

```text
embedded-rtos/
├── Makefile
├── README.md
├── LICENSE
│
├── apps/
│   ├── 00_bringup/
│   │   └── main.c
│   │
│   └── 01_blink/
│       ├── main.c
│       └── README.md
│
├── boards/
│   └── nucleo-f411re/
│       ├── startup.S
│       └── linker.ld
│
└── docs/
    └── media/
        └── 01_blink.gif
```

---

## Applications

| App | Purpose | Status |
|---|---|---|
| `00_bringup` | Minimal reset-to-`main()` validation | Verified |
| `01_blink` | Bare-metal GPIO blink on PA5/LD2 | Verified |

---

## Requirements

### Required to build

- GNU Make
- Arm GNU Toolchain:
  - `arm-none-eabi-gcc`
  - `arm-none-eabi-objcopy`
  - `arm-none-eabi-size`

### Required to flash/debug on hardware

- Nucleo-F411RE board
- OpenOCD
- GDB:
  - `gdb-multiarch` or `arm-none-eabi-gdb`

### Required only for WSL2 USB passthrough

- `usbipd-win`
- `usbutils` inside WSL for `lsusb`

---

## Verify Tool Installation

Run:

```bash
make --version
arm-none-eabi-gcc --version
arm-none-eabi-objcopy --version
arm-none-eabi-size --version
openocd --version
gdb-multiarch --version
```

If using WSL2, confirm the ST-LINK appears inside WSL:

```bash
lsusb
```

Expected: a device from STMicroelectronics / ST-LINK should appear.

---

## Build

Clone the repo:

```bash
git clone https://github.com/dhart83/embedded-rtos.git
cd embedded-rtos
```

Show available Make targets:

```bash
make help
```

Build the GPIO blink app:

```bash
make deepclean
make APP=01_blink
```

Build output:

```text
build/01_blink/01_blink.elf
```

Show size:

```bash
make APP=01_blink size
```

Optional binary and HEX artifacts:

```bash
make APP=01_blink bin
make APP=01_blink hex
```

---

## Run Without Hardware

Without a board, you can still build and inspect the firmware image.

```bash
make deepclean
make APP=01_blink
make APP=01_blink size
```

Inspect key symbols:

```bash
arm-none-eabi-nm build/01_blink/01_blink.elf | grep -E "Reset_Handler|main|_estack|__isr_vector"
```

Expected symbols include:

```text
Reset_Handler
main
_estack
__isr_vector
```

Inspect sections:

```bash
arm-none-eabi-objdump -h build/01_blink/01_blink.elf
```

The vector table should be placed at the beginning of Flash:

```text
.isr_vector  0x08000000
```

This confirms the firmware image is structurally reasonable, but it does not prove the firmware runs. Hardware is required for that.

---

## Flash to Hardware

Connect the Nucleo-F411RE board.

Flash the GPIO blink app:

```bash
make APP=01_blink flash
```

Expected OpenOCD output should include:

```text
Programming Started
Programming Finished
Verify Started
Verified OK
Resetting Target
```

After flashing, the onboard LD2 LED should blink.

---

## Debug With OpenOCD and GDB

Terminal 1:

```bash
make openocd
```

Expected output should include:

```text
Cortex-M4 processor detected
Listening on port 3333 for gdb connections
```

Terminal 2:

```bash
make APP=01_blink debug
```

Inside GDB:

```gdb
target extended-remote localhost:3333
monitor reset halt
break Reset_Handler
continue
break main
continue
```

Expected result:

- GDB stops at `Reset_Handler`
- GDB then reaches `main`

This verifies the startup path:

```text
Vector table → Reset_Handler → main()
```

---

## WSL2 USB Notes

If using WSL2, USB devices must be attached from Windows to WSL before OpenOCD can access ST-LINK.

From Windows PowerShell:

```powershell
usbipd list
usbipd bind --busid <BUSID>
usbipd attach --wsl --busid <BUSID>
```

Then inside WSL:

```bash
lsusb
```

Once ST-LINK appears in WSL, OpenOCD should be able to connect.

---

## Current Make Targets

```text
make                    Build default app ELF
make APP=01_blink       Build selected app
make APP=01_blink bin   Build binary artifact
make APP=01_blink hex   Build Intel HEX artifact
make APP=01_blink size  Show ELF size
make APP=01_blink flash Flash ELF with OpenOCD
make openocd            Start OpenOCD server
make APP=01_blink debug Start GDB with ELF symbols
make clean              Remove current app build output
make deepclean          Remove full build directory
make help               Show available targets
```

---

## References

### Board and MCU

- [Nucleo-64 User Manual UM1724](https://www.st.com/resource/en/user_manual/um1724-stm32-nucleo64-boards-mb1136-stmicroelectronics.pdf)
- [STM32F411RE Product Page](https://www.st.com/en/microcontrollers-microprocessors/stm32f411re.html)
- [STM32F411 Reference Manual RM0383](https://www.st.com/resource/en/reference_manual/rm0383-stm32f411xce-advanced-armbased-32bit-mcus-stmicroelectronics.pdf)
- [STM32 Cortex-M4 Programming Manual PM0214](https://www.st.com/resource/en/programming_manual/pm0214-stm32-cortexm4-mcus-and-mpus-programming-manual-stmicroelectronics.pdf)

### Arm Cortex-M

- [Arm Cortex-M4 Devices Generic User Guide](https://developer.arm.com/documentation/dui0553/b/)

### C, GCC, Make, and Linker

- [C11 Draft N1570](https://www.iso-9899.info/n1570.html)
- [Arm GNU Toolchain Downloads](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)
- [GCC ARM Options](https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html)
- [GNU Make Manual](https://www.gnu.org/software/make/manual/make.html)
- [GNU ld Linker Scripts Manual](https://sourceware.org/binutils/docs/ld/Scripts.html)

### Flashing and Debugging

- [OpenOCD](https://openocd.org/)
- [GDB Manual](https://sourceware.org/gdb/current/onlinedocs/gdb)
- [Microsoft WSL USB / usbipd-win Guide](https://learn.microsoft.com/en-us/windows/wsl/connect-usb)

---

## License

This project is licensed under the MIT License.
