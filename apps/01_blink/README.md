# 01_blink

Bare-metal GPIO bring-up for the Nucleo-F411RE.

This app enables the GPIOA peripheral clock, configures PA5/LD2 as a general-purpose output, and toggles it using direct register access.

## Verified

- Builds with `make APP=01_blink`
- Flashes with `make APP=01_blink flash`
- Onboard LD2 LED blinks