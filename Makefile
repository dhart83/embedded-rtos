# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
BOARD 				:= nucleo-f411re
CPU   				:= cortex-m4
APP   				:= 00_bringup

# Toolchain
CROSS   			:= arm-none-eabi
CC      			:= $(CROSS)-gcc
OBJCOPY 			:= $(CROSS)-objcopy
SIZE    			:= $(CROSS)-size
GDB     			:= gdb-multiarch
OPENOCD 			:= openocd

OPENOCD_CFG 		:= board/st_nucleo_f4.cfg

# -----------------------------------------------------------------------------
# Project layout
# -----------------------------------------------------------------------------
APP_DIR       		:= apps/$(APP)
BOARD_DIR     		:= boards/$(BOARD)
BUILD_DIR     		:= build
APP_BUILD_DIR 		:= $(BUILD_DIR)/$(APP)

LD_SCRIPT 			:= $(BOARD_DIR)/linker.ld

ELF 				:= $(APP_BUILD_DIR)/$(APP).elf
BIN 				:= $(APP_BUILD_DIR)/$(APP).bin
HEX 				:= $(APP_BUILD_DIR)/$(APP).hex
MAP 				:= $(APP_BUILD_DIR)/$(APP).map

# -----------------------------------------------------------------------------
# Sources
# -----------------------------------------------------------------------------
C_SRCS := \
	$(APP_DIR)/main.c

S_SRCS := \
	$(BOARD_DIR)/startup.S

OBJS := \
	$(patsubst $(APP_DIR)/%.c,$(APP_BUILD_DIR)/%.o,$(C_SRCS)) \
	$(patsubst $(BOARD_DIR)/%.S,$(APP_BUILD_DIR)/%.o,$(S_SRCS))

DEPS := $(OBJS:.o=.d)

# -----------------------------------------------------------------------------
# Flags
# -----------------------------------------------------------------------------
CPUFLAGS 			:= -mcpu=$(CPU) -mthumb

CFLAGS 				:= $(CPUFLAGS)
CFLAGS 				+= -Og -g3
CFLAGS 				+= -Wall -Wextra
CFLAGS 				+= -ffreestanding -fno-builtin -fno-common
CFLAGS 				+= -ffunction-sections -fdata-sections
CFLAGS 				+= -MMD -MP

ASFLAGS 			:= $(CPUFLAGS)
ASFLAGS 			+= -Og -g3

LDFLAGS 			:= $(CPUFLAGS)
LDFLAGS 			+= -nostdlib
LDFLAGS 			+= -T $(LD_SCRIPT)
LDFLAGS 			+= -Wl,-Map=$(MAP)
LDFLAGS 			+= -Wl,--gc-sections

# -----------------------------------------------------------------------------
# Targets
# -----------------------------------------------------------------------------
.PHONY: all bin hex size flash openocd debug clean deepclean help

all: $(ELF)

$(APP_BUILD_DIR)/%.o: $(APP_DIR)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(APP_BUILD_DIR)/%.o: $(BOARD_DIR)/%.S
	mkdir -p $(dir $@)
	$(CC) $(ASFLAGS) -x assembler-with-cpp -c $< -o $@

$(ELF): $(OBJS)
	mkdir -p $(dir $@)
	$(CC) $(LDFLAGS) $^ -o $@

bin: $(ELF)
	$(OBJCOPY) -O binary $< $(BIN)

hex: $(ELF)
	$(OBJCOPY) -O ihex $< $(HEX)

size: $(ELF)
	$(SIZE) $<

flash: $(ELF)
	$(OPENOCD) -f $(OPENOCD_CFG) -c "program $(ELF) verify reset exit"

openocd:
	$(OPENOCD) -f $(OPENOCD_CFG)

debug: $(ELF)
	$(GDB) $(ELF)

clean:
	rm -rf $(APP_BUILD_DIR)

deepclean:
	rm -rf $(BUILD_DIR)

help:
	@echo "Targets:"
	@echo "  all       Build ELF ($(ELF))"
	@echo "  bin       Build binary"
	@echo "  hex       Build Intel HEX"
	@echo "  size      Show ELF size"
	@echo "  flash     Flash ELF with OpenOCD"
	@echo "  openocd   Start OpenOCD server"
	@echo "  debug     Start GDB with ELF symbols"
	@echo "  clean     Remove current app build output"
	@echo "  deepclean Remove full build directory"

-include $(DEPS)