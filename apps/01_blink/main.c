/*
 * App: 01_blink
 * Target: Nucleo-F411RE / STM32F411RE
 * Purpose: Toggle PA5/LD2 using direct GPIO register access
 */

#include <stdint.h>

int main(void)
{
    volatile uint32_t * const RCC_AHB1ENR = (volatile uint32_t *)0x40023830UL; // RCC base 0x40023800 + AHB1ENR offset 0x30
    volatile uint32_t * const GPIOA_MODER = (volatile uint32_t *)0x40020000UL; // GPIOA base 0x40020000 + MODER offset 0x00
    volatile uint32_t * const GPIOA_ODR   = (volatile uint32_t *)0x40020014UL; // GPIOA base 0x40020000 + ODR offset 0x14

    // Enable GPIOA clock
    *RCC_AHB1ENR |= (1UL << 0); // RCC_AHB1ENR bit 0 = GPIOAEN
    (void)*RCC_AHB1ENR;         // Readback after enabling peripheral clock

    // Configure PA5 as general-purpose output
    // PA5 mode field = bits [11:10]
    // 01 = general-purpose output
    *GPIOA_MODER &= ~(3UL << 10); // Clear PA5 mode field
    *GPIOA_MODER |=  (1UL << 10); // Set PA5 mode to 01

    while (1)
    {
        // Drive PA5 high
        *GPIOA_ODR |= (1UL << 5);

        // Crude blocking delay
        for (volatile uint32_t i = 0; i < 1000000UL; i++)
        {
        }

        // Drive PA5 low
        *GPIOA_ODR &= ~(1UL << 5);

        // Crude blocking delay
        for (volatile uint32_t i = 0; i < 1000000UL; i++)
        {
        }
    }
}