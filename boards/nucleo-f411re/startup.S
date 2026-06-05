/* ============================================================================
 * Startup (Nucleo-F411RE / STM32F411RE / Cortex-M4)
 *
 * This file defines the minimal symbols required for a Cortex-M system to
 * enter known code after reset and to route exceptions/IRQs to defined handlers.
 *
 * This file contains:
 *   1) Vector table layout (data)
 *   2) Handler implementations (code)
 *   3) Handler binding/aliasing policy (linkage)
 * ============================================================================
 */


.syntax unified
.cpu cortex-m4
.thumb

/* External Dependencies */
.extern main

/* Exported symbols */
.global __isr_vector
.type   __isr_vector, %object

.global Reset_Handler
.type   Reset_Handler, %function

.global HardFault_Handler
.type   HardFault_Handler, %function

.global Default_Handler
.type   Default_Handler, %function


/* ----------------------------------------------------------------------------
 * 1) Vector Table (.isr_vector)
 *
 * Responsibilities:
 * - Provide the Cortex-M vector table in a dedicated section so the linker can
 *   place it at the expected FLASH base address.
 * - Define the initial stack pointer value.
 * - Define the Reset_Handler entry.
 * - Define entries for core exceptions and peripheral IRQs (either real handlers
 *   or defaults).
 *
 * Notes:
 * - The CPU reads vector[0] (SP) and vector[1] (Reset_Handler) directly at reset.
 * - The exact table order is defined by the Cortex-M exception model.
 * - .type and .size used for clean tooling output
 * ----------------------------------------------------------------------------
 */


.section .isr_vector,"a",%progbits
.align 2

__isr_vector:
    /* 0: Initial stack pointer */
    .word   _estack                         /*                       0x000 */                         

    /* 1–15: Cortex-M core exceptions */
    .word   Reset_Handler                   /*  1: Reset             0x004 */
    .word   NMI_Handler                     /*  2: NMI               0x008 */
    .word   HardFault_Handler               /*  3: HardFault         0x00C */
    .word   MemManage_Handler               /*  4: MemManage         0x010 */
    .word   BusFault_Handler                /*  5: BusFault          0x014 */
    .word   UsageFault_Handler              /*  6: UsageFault        0x018 */
    .word   0                               /*  7: Reserved          0x01C */
    .word   0                               /*  8: Reserved          0x020 */
    .word   0                               /*  9: Reserved          0x024 */
    .word   0                               /* 10: Reserved          0x028 */
    .word   SVC_Handler                     /* 11: SVCall            0x02C */
    .word   DebugMon_Handler                /* 12: Debug Monitor     0x030 */
    .word   0                               /* 13: Reserved          0x034 */
    .word   PendSV_Handler                  /* 14: PendSV            0x038 */
    .word   SysTick_Handler                 /* 15: SysTick           0x03C */

    /* 16+ : External interrupts (IRQn = index-16) */

    .word   WWDG_IRQHandler                 /* 16: IRQ0   WWDG                   0x040 */
    .word   PVD_IRQHandler                  /* 17: IRQ1   EXTI16/PVD             0x044 */
    .word   TAMP_STAMP_IRQHandler           /* 18: IRQ2   EXTI21/TAMP_STAMP      0x048 */
    .word   RTC_WKUP_IRQHandler             /* 19: IRQ3   EXTI22/RTC_WKUP        0x04C */
    .word   FLASH_IRQHandler                /* 20: IRQ4   FLASH                  0x050 */
    .word   RCC_IRQHandler                  /* 21: IRQ5   RCC                    0x054 */
    .word   EXTI0_IRQHandler                /* 22: IRQ6   EXTI0                  0x058 */
    .word   EXTI1_IRQHandler                /* 23: IRQ7   EXTI1                  0x05C */
    .word   EXTI2_IRQHandler                /* 24: IRQ8   EXTI2                  0x060 */
    .word   EXTI3_IRQHandler                /* 25: IRQ9   EXTI3                  0x064 */
    .word   EXTI4_IRQHandler                /* 26: IRQ10  EXTI4                  0x068 */
    .word   DMA1_Stream0_IRQHandler         /* 27: IRQ11  DMA1 Stream0           0x06C */
    .word   DMA1_Stream1_IRQHandler         /* 28: IRQ12  DMA1 Stream1           0x070 */
    .word   DMA1_Stream2_IRQHandler         /* 29: IRQ13  DMA1 Stream2           0x074 */
    .word   DMA1_Stream3_IRQHandler         /* 30: IRQ14  DMA1 Stream3           0x078 */
    .word   DMA1_Stream4_IRQHandler         /* 31: IRQ15  DMA1 Stream4           0x07C */
    .word   DMA1_Stream5_IRQHandler         /* 32: IRQ16  DMA1 Stream5           0x080 */
    .word   DMA1_Stream6_IRQHandler         /* 33: IRQ17  DMA1 Stream6           0x084 */
    .word   ADC_IRQHandler                  /* 34: IRQ18  ADC                    0x088 */

    /* 35–38: CAN on some F4 parts – F411 has no CAN → reserved */
    .word   0                               /* 35: IRQ19  Reserved (CAN1_TX)     0x08C */
    .word   0                               /* 36: IRQ20  Reserved (CAN1_RX0)    0x090 */
    .word   0                               /* 37: IRQ21  Reserved (CAN1_RX1)    0x094 */
    .word   0                               /* 38: IRQ22  Reserved (CAN1_SCE)    0x098 */

    .word   EXTI9_5_IRQHandler              /* 39: IRQ23  EXTI9_5                0x09C */
    .word   TIM1_BRK_TIM9_IRQHandler        /* 40: IRQ24  TIM1_BRK/TIM9          0x0A0 */
    .word   TIM1_UP_TIM10_IRQHandler        /* 41: IRQ25  TIM1_UP/TIM10          0x0A4 */
    .word   TIM1_TRG_COM_TIM11_IRQHandler   /* 42: IRQ26  TIM1_TRG_COM/TIM11     0x0A8 */
    .word   TIM1_CC_IRQHandler              /* 43: IRQ27  TIM1_CC                0x0AC */
    .word   TIM2_IRQHandler                 /* 44: IRQ28  TIM2                   0x0B0 */
    .word   TIM3_IRQHandler                 /* 45: IRQ29  TIM3                   0x0B4 */
    .word   TIM4_IRQHandler                 /* 46: IRQ30  TIM4                   0x0B8 */
    .word   I2C1_EV_IRQHandler              /* 47: IRQ31  I2C1_EV                0x0BC */
    .word   I2C1_ER_IRQHandler              /* 48: IRQ32  I2C1_ER                0x0C0 */
    .word   I2C2_EV_IRQHandler              /* 49: IRQ33  I2C2_EV                0x0C4 */
    .word   I2C2_ER_IRQHandler              /* 50: IRQ34  I2C2_ER                0x0C8 */
    .word   SPI1_IRQHandler                 /* 51: IRQ35  SPI1                   0x0CC */
    .word   SPI2_IRQHandler                 /* 52: IRQ36  SPI2                   0x0D0 */
    .word   USART1_IRQHandler               /* 53: IRQ37  USART1                 0x0D4 */
    .word   USART2_IRQHandler               /* 54: IRQ38  USART2                 0x0D8 */
    .word   0                               /* 55: IRQ39  Reserved               0x0DC */
    .word   EXTI15_10_IRQHandler            /* 56: IRQ40  EXTI15_10              0x0E0 */
    .word   RTC_Alarm_IRQHandler            /* 57: IRQ41  EXTI17/RTC_Alarm       0x0E4 */
    .word   OTG_FS_WKUP_IRQHandler          /* 58: IRQ42  EXTI18/OTG_FS_WKUP     0x0E8 */

    /* 59–62: reserved */
    .word   0                               /* 59: IRQ43  Reserved               0x0EC */
    .word   0                               /* 60: IRQ44  Reserved               0x0F0 */
    .word   0                               /* 61: IRQ45  Reserved               0x0F4 */
    .word   0                               /* 62: IRQ46  Reserved               0x0F8 */

    .word   DMA1_Stream7_IRQHandler         /* 63: IRQ47  DMA1 Stream7           0x0FC */

    /* 64: reserved */
    .word   0                               /* 64: IRQ48  Reserved               0x100 */

    .word   SDIO_IRQHandler                 /* 65: IRQ49  SDIO                   0x104 */
    .word   TIM5_IRQHandler                 /* 66: IRQ50  TIM5                   0x108 */
    .word   SPI3_IRQHandler                 /* 67: IRQ51  SPI3                   0x10C */

    /* 68–71: reserved */
    .word   0                               /* 68: IRQ52  Reserved               0x110 */
    .word   0                               /* 69: IRQ53  Reserved               0x114 */
    .word   0                               /* 70: IRQ54  Reserved               0x118 */
    .word   0                               /* 71: IRQ55  Reserved               0x11C */

    .word   DMA2_Stream0_IRQHandler         /* 72: IRQ56  DMA2 Stream0           0x120 */
    .word   DMA2_Stream1_IRQHandler         /* 73: IRQ57  DMA2 Stream1           0x124 */
    .word   DMA2_Stream2_IRQHandler         /* 74: IRQ58  DMA2 Stream2           0x128 */
    .word   DMA2_Stream3_IRQHandler         /* 75: IRQ59  DMA2 Stream3           0x12C */
    .word   DMA2_Stream4_IRQHandler         /* 76: IRQ60  DMA2 Stream4           0x130 */

    /* 77–82: reserved */
    .word   0                               /* 77: IRQ61  Reserved               0x134 */
    .word   0                               /* 78: IRQ62  Reserved               0x138 */
    .word   0                               /* 79: IRQ63  Reserved               0x13C */
    .word   0                               /* 80: IRQ64  Reserved               0x140 */
    .word   0                               /* 81: IRQ65  Reserved               0x144 */
    .word   0                               /* 82: IRQ66  Reserved               0x148 */

    .word   OTG_FS_IRQHandler               /* 83: IRQ67  OTG_FS global          0x14C */
    .word   DMA2_Stream5_IRQHandler         /* 84: IRQ68  DMA2 Stream5           0x150 */
    .word   DMA2_Stream6_IRQHandler         /* 85: IRQ69  DMA2 Stream6           0x154 */
    .word   DMA2_Stream7_IRQHandler         /* 86: IRQ70  DMA2 Stream7           0x158 */
    .word   USART6_IRQHandler               /* 87: IRQ71  USART6                 0x15C */
    .word   I2C3_EV_IRQHandler              /* 88: IRQ72  I2C3_EV                0x160 */
    .word   I2C3_ER_IRQHandler              /* 89: IRQ73  I2C3_ER                0x164 */

    /* 90–96: reserved */
    .word   0                               /* 90: IRQ74  Reserved               0x168 */
    .word   0                               /* 91: IRQ75  Reserved               0x16C */
    .word   0                               /* 92: IRQ76  Reserved               0x170 */
    .word   0                               /* 93: IRQ77  Reserved               0x174 */
    .word   0                               /* 94: IRQ78  Reserved               0x178 */
    .word   0                               /* 95: IRQ79  Reserved               0x17C */
    .word   0                               /* 96: IRQ80  Reserved               0x180 */

    .word   FPU_IRQHandler                  /* 97: IRQ81  FPU                    0x184 */

    /* 98–99: reserved */
    .word   0                               /* 98: IRQ82  Reserved               0x188 */
    .word   0                               /* 99: IRQ83  Reserved               0x18C */

    .word   SPI4_IRQHandler                 /* 100: IRQ84 SPI4                   0x190 */
    .word   SPI5_IRQHandler                 /* 101: IRQ85 SPI5                   0x194 */

.size __isr_vector, . - __isr_vector


/* ----------------------------------------------------------------------------
 * 2) Handler Code (executable)
 *
 * Responsibilities:
 * - Implement Reset_Handler (system entry point after reset).
 * - Implement Default_Handler (safe sink for unhandled exceptions/IRQs).
 * - Optionally implement a small number of core fault handlers explicitly
 *   (e.g., HardFault) as the project evolves.

  * Notes:
 * - .type and .size used for clean tooling output
 * ----------------------------------------------------------------------------
 */


/* Reset Handler*/
.section .text.Reset_Handler,"ax",%progbits
.thumb_func
Reset_Handler:
    /* Copy .data from FLASH to RAM */
    ldr     r0, =_sidata
    ldr     r1, =_sdata
    ldr     r2, =_edata

copy_data_loop:
    cmp     r1, r2
    bcs     zero_bss
    ldr     r3, [r0], #4
    str     r3, [r1], #4
    b       copy_data_loop

zero_bss:
    ldr     r0, =_sbss
    ldr     r1, =_ebss
    movs    r2, #0

zero_bss_loop:
    cmp     r0, r1
    bcs     call_main
    str     r2, [r0], #4
    b       zero_bss_loop

call_main:
    bl      main

hang:
    b       hang         /* If main returns, spin forever */

.size Reset_Handler, . - Reset_Handler


/* HardFault Handler */
.section .text.HardFault_Handler,"ax",%progbits
.thumb_func
HardFault_Handler:
1:
    b   1b

.size Hardault_Handler, . - HardFault_Handler


/* Default Handler */
.section .text.Default_Handler,"ax",%progbits
.thumb_func
Default_Handler:
1:
    b   1b

.size Default_Handler, . - Default_Handler


/* ----------------------------------------------------------------------------
 * 3) Handler Aliases / Weak Bindings (linkage policy)
 *
 * Responsibilities:
 * - Provide weak symbols for exceptions/IRQs that resolve to Default_Handler
 *   unless overridden elsewhere by a strong definition.
 * - Keep the policy for "what happens when nothing is implemented" explicit.
 *
 * Notes:
 * - This enables incremental development: add a real handler later by defining
 *   the same symbol name in another translation unit.
 * ----------------------------------------------------------------------------
 */


.macro WEAK_ALIAS name, target
    .weak \name
    .type \name, %function
    .thumb_set \name, \target
.endm


/* Core Exceptions */
WEAK_ALIAS NMI_Handler,                     Default_Handler
WEAK_ALIAS HardFault_Handler,               HardFault_Handler
WEAK_ALIAS MemManage_Handler,               Default_Handler
WEAK_ALIAS BusFault_Handler,                Default_Handler
WEAK_ALIAS UsageFault_Handler,              Default_Handler
WEAK_ALIAS SVC_Handler,                     Default_Handler
WEAK_ALIAS DebugMon_Handler,                Default_Handler
WEAK_ALIAS PendSV_Handler,                  Default_Handler
WEAK_ALIAS SysTick_Handler,                 Default_Handler


/* Peripheral IRQs */
WEAK_ALIAS WWDG_IRQHandler,                 Default_Handler
WEAK_ALIAS PVD_IRQHandler,                  Default_Handler
WEAK_ALIAS TAMP_STAMP_IRQHandler,           Default_Handler
WEAK_ALIAS RTC_WKUP_IRQHandler,             Default_Handler
WEAK_ALIAS FLASH_IRQHandler,                Default_Handler
WEAK_ALIAS RCC_IRQHandler,                  Default_Handler
WEAK_ALIAS EXTI0_IRQHandler,                Default_Handler
WEAK_ALIAS EXTI1_IRQHandler,                Default_Handler
WEAK_ALIAS EXTI2_IRQHandler,                Default_Handler
WEAK_ALIAS EXTI3_IRQHandler,                Default_Handler
WEAK_ALIAS EXTI4_IRQHandler,                Default_Handler
WEAK_ALIAS DMA1_Stream0_IRQHandler,         Default_Handler
WEAK_ALIAS DMA1_Stream1_IRQHandler,         Default_Handler
WEAK_ALIAS DMA1_Stream2_IRQHandler,         Default_Handler
WEAK_ALIAS DMA1_Stream3_IRQHandler,         Default_Handler
WEAK_ALIAS DMA1_Stream4_IRQHandler,         Default_Handler
WEAK_ALIAS DMA1_Stream5_IRQHandler,         Default_Handler
WEAK_ALIAS DMA1_Stream6_IRQHandler,         Default_Handler
WEAK_ALIAS ADC_IRQHandler,                  Default_Handler
WEAK_ALIAS EXTI9_5_IRQHandler,              Default_Handler
WEAK_ALIAS TIM1_BRK_TIM9_IRQHandler,        Default_Handler
WEAK_ALIAS TIM1_UP_TIM10_IRQHandler,        Default_Handler
WEAK_ALIAS TIM1_TRG_COM_TIM11_IRQHandler,   Default_Handler
WEAK_ALIAS TIM1_CC_IRQHandler,              Default_Handler
WEAK_ALIAS TIM2_IRQHandler,                 Default_Handler
WEAK_ALIAS TIM3_IRQHandler,                 Default_Handler
WEAK_ALIAS TIM4_IRQHandler,                 Default_Handler
WEAK_ALIAS I2C1_EV_IRQHandler,              Default_Handler
WEAK_ALIAS I2C1_ER_IRQHandler,              Default_Handler
WEAK_ALIAS I2C2_EV_IRQHandler,              Default_Handler
WEAK_ALIAS I2C2_ER_IRQHandler,              Default_Handler
WEAK_ALIAS SPI1_IRQHandler,                 Default_Handler
WEAK_ALIAS SPI2_IRQHandler,                 Default_Handler
WEAK_ALIAS USART1_IRQHandler,               Default_Handler
WEAK_ALIAS USART2_IRQHandler,               Default_Handler
WEAK_ALIAS EXTI15_10_IRQHandler,            Default_Handler
WEAK_ALIAS RTC_Alarm_IRQHandler,            Default_Handler
WEAK_ALIAS OTG_FS_WKUP_IRQHandler,          Default_Handler
WEAK_ALIAS DMA1_Stream7_IRQHandler,         Default_Handler
WEAK_ALIAS SDIO_IRQHandler,                 Default_Handler
WEAK_ALIAS TIM5_IRQHandler,                 Default_Handler
WEAK_ALIAS SPI3_IRQHandler,                 Default_Handler
WEAK_ALIAS DMA2_Stream0_IRQHandler,         Default_Handler
WEAK_ALIAS DMA2_Stream1_IRQHandler,         Default_Handler
WEAK_ALIAS DMA2_Stream2_IRQHandler,         Default_Handler
WEAK_ALIAS DMA2_Stream3_IRQHandler,         Default_Handler
WEAK_ALIAS DMA2_Stream4_IRQHandler,         Default_Handler
WEAK_ALIAS OTG_FS_IRQHandler,               Default_Handler
WEAK_ALIAS DMA2_Stream5_IRQHandler,         Default_Handler
WEAK_ALIAS DMA2_Stream6_IRQHandler,         Default_Handler
WEAK_ALIAS DMA2_Stream7_IRQHandler,         Default_Handler
WEAK_ALIAS USART6_IRQHandler,               Default_Handler
WEAK_ALIAS I2C3_EV_IRQHandler,              Default_Handler
WEAK_ALIAS I2C3_ER_IRQHandler,              Default_Handler
WEAK_ALIAS FPU_IRQHandler,                  Default_Handler
WEAK_ALIAS SPI4_IRQHandler,                 Default_Handler
WEAK_ALIAS SPI5_IRQHandler,                 Default_Handler
