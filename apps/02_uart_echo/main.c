/*
 * App: 02_uart_echo
 * Target: Nucleo-F411RE / STM32F411RE
 * Purpose: Verify polling USART2 transmit and receive over the ST-LINK virtual COM port.
 *
 * Route:
 *   USART2_TX -> PA2 -> ST-LINK VCP -> USB -> PC terminal
 *   USART2_RX <- PA3 <- ST-LINK VCP <- USB <- PC terminal
 */

#include <stdint.h>

// RCC
static volatile uint32_t * const RCC_AHB1ENR = (volatile uint32_t *)0x40023830UL; // RCC base 0x40023800 + AHB1ENR offset 0x30
static volatile uint32_t * const RCC_APB1ENR = (volatile uint32_t *)0x40023840UL; // RCC base 0x40023800 + APB1ENR offset 0x40

// GPIOA
static volatile uint32_t * const GPIOA_MODER = (volatile uint32_t *)0x40020000UL; // GPIOA base 0x40020000 + MODER offset 0x00
static volatile uint32_t * const GPIOA_AFRL  = (volatile uint32_t *)0x40020020UL; // GPIOA base 0x40020000 + AFRL offset 0x20

// USART2
static volatile uint32_t * const USART2_SR  = (volatile uint32_t *)0x40004400UL; // USART2 base 0x40004400 + SR offset 0x00
static volatile uint32_t * const USART2_DR  = (volatile uint32_t *)0x40004404UL; // USART2 base 0x40004400 + DR offset 0x04
static volatile uint32_t * const USART2_BRR = (volatile uint32_t *)0x40004408UL; // USART2 base 0x40004400 + BRR offset 0x08
static volatile uint32_t * const USART2_CR1 = (volatile uint32_t *)0x4000440CUL; // USART2 base 0x40004400 + CR1 offset 0x0C
static volatile uint32_t * const USART2_CR2 = (volatile uint32_t *)0x40004410UL; // USART2 base 0x40004400 + CR2 offset 0x10
static volatile uint32_t * const USART2_CR3 = (volatile uint32_t *)0x40004414UL; // USART2 base 0x40004400 + CR3 offset 0x14


static void uart2_config(void)
{
    // Enable GPIOA peripheral clock.
    *RCC_AHB1ENR |= (1UL << 0); // GPIOAEN
    (void)*RCC_AHB1ENR;         // Readback after enabling peripheral clock.

    // Enable USART2 peripheral clock.
    *RCC_APB1ENR |= (1UL << 17); // USART2EN
    (void)*RCC_APB1ENR;          // Readback after enabling peripheral clock.

    // Select AF7 for PA2 and PA3.
    // PA2 AFRL field = bits [11:8].
    // PA3 AFRL field = bits [15:12].
    *GPIOA_AFRL &= ~(0xFUL << 8);
    *GPIOA_AFRL |=  (7UL   << 8);

    *GPIOA_AFRL &= ~(0xFUL << 12);
    *GPIOA_AFRL |=  (7UL   << 12);

    // Configure PA2 and PA3 as alternate function mode.
    // PA2 MODER field = bits [5:4].
    // PA3 MODER field = bits [7:6].
    // Alternate function mode = 10.
    *GPIOA_MODER &= ~(0x3UL << 4);
    *GPIOA_MODER |=  (2UL   << 4);

    *GPIOA_MODER &= ~(0x3UL << 6);
    *GPIOA_MODER |=  (2UL   << 6);

    // Configure USART2 for 8 data bits, no parity, 1 stop bit.
    *USART2_CR1 &= ~(1UL << 12);    // M = 0: 8 data bits.
    *USART2_CR2 &= ~(0x3UL << 12);  // STOP = 00: 1 stop bit.
    *USART2_CR3 &= ~(1UL << 7);     // DMAT = 0: DMA transmit disabled.

    /*
     * Configure baud rate.
     *
     * USART2 is on APB1.
     * Current assumption: no system clock setup has been performed, so PCLK1 = 16 MHz.
     * Baud: 115200
     * Oversampling: 16
     *
     * USARTDIV = 16,000,000 / (16 * 115,200) = 8.6805
     * Mantissa = 8
     * Fraction = round(0.6805 * 16) = 11
     * BRR = (8 << 4) | 11 = 0x008B
     */
    *USART2_BRR = 0x008B;

    // Enable transmitter and receiver.
    *USART2_CR1 |= (1UL << 3); // TE
    *USART2_CR1 |= (1UL << 2); // RE

    // Enable USART2.
    *USART2_CR1 |= (1UL << 13); // UE
}

static uint8_t uart2_rx_byte(void)
{
    while (((*USART2_SR >> 5) & 1UL) == 0UL)
    {
    }

    return (uint8_t)(*USART2_DR & 0xFFUL);
}

static void uart2_tx_byte(uint8_t byte)
{
    while (((*USART2_SR >> 7) & 1UL) == 0UL)
    {
    }
    *USART2_DR = byte;
}

static void uart2_tx_string(const char * str)
{
    while (*str != '\0')
    {
        uart2_tx_byte((uint8_t)*str);
        str++;
    }

    // Wait until the final byte has fully transmitted.
    while (((*USART2_SR >> 6) & 1UL) == 0UL)
    {
    }
}


int main(void)
{
    uart2_config();

    uart2_tx_string("UART echo ready\r\n");

    while (1)
    {
        uint8_t rx_byte = uart2_rx_byte();
        uart2_tx_byte(rx_byte);

        // Add a line feed so cursor moves to the next line when Enter is pressed
        if (rx_byte == (uint8_t)'\r')
        {
            uart2_tx_byte((uint8_t)'\n');
        }
    }
}