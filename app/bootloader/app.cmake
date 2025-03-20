# 添加app sources, 注意必须加上CMAKE_CURRENT_LIST_DIR!
set(app_src
    ${CMAKE_CURRENT_LIST_DIR}/cubemx/startup_stm32f410rx.s
    ${CMAKE_CURRENT_LIST_DIR}/cubemx/Core/Src/gpio.c
    ${CMAKE_CURRENT_LIST_DIR}/cubemx/Core/Src/main.c
    ${CMAKE_CURRENT_LIST_DIR}/cubemx/Core/Src/stm32f4xx_hal_msp.c
    ${CMAKE_CURRENT_LIST_DIR}/cubemx/Core/Src/stm32f4xx_it.c
    ${CMAKE_CURRENT_LIST_DIR}/cubemx/Core/Src/syscalls.c
    ${CMAKE_CURRENT_LIST_DIR}/cubemx/Core/Src/sysmem.c
    ${CMAKE_CURRENT_LIST_DIR}/cubemx/Core/Src/system_stm32f4xx.c
    ${CMAKE_CURRENT_LIST_DIR}/cubemx/Core/Src/usart.c
    ${CMAKE_CURRENT_LIST_DIR}/cubemx/Core/Src/FLASH_SECTOR_F4.c

	${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_uart.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc_ex.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ex.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ramfunc.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma_ex.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr_ex.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c
    ${CMAKE_CURRENT_LIST_DIR}/../../STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_exti.c
)



# 添加app include dirs, 注意必须加上CMAKE_CURRENT_LIST_DIR!
set(app_inc
	${CMAKE_CURRENT_LIST_DIR}/cubemx/Core/Inc
)

# 添加app compile options
set(app_compile_options
)

# 添加app link options
set(app_link_options
	-T ${CMAKE_CURRENT_LIST_DIR}/stm32f410rbtx_flash.ld
)

# 添加app dependencies
set(app_dep
)