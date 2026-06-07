# 01_blink

Bare-metal GPIO bring-up for the Nucleo-F411RE.

This app enables the GPIOA peripheral clock, configures PA5/LD2 as a general-purpose output, and toggles the onboard LED using direct register access.

![GPIO blink demo](../../docs/media/01_blink.gif)

## Verified

- Builds with `make APP=01_blink`
- Flashes with `make APP=01_blink flash`
- Onboard LD2 LED blinks

## Hardware Notes

- Board: Nucleo-F411RE
- MCU: STM32F411RE
- LED: LD2 on PA5
- GPIO port: GPIOA
- Clock enable: `RCC_AHB1ENR.GPIOAEN`
- Pin mode: `GPIOA_MODER[11:10] = 01`
- Output register: `GPIOA_ODR`

## Run

```bash
make APP=01_blink
make APP=01_blink flash
```
