#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "stm32f4xx_hal.h"

bool update_needed()
{
    // Check if the application needs to be updated
    return false;
}

void update_or_jump_to_app()
{
    if(!update_needed())
    {
        // Jump to the application
        uint32_t* app_base = (void*)0x08004000;
        uint32_t app_msp = app_base[0];
        uint32_t app_reset_vector = app_base[1];
        __asm("msr msp, %0" : : "r" (app_msp));
        __asm("bx %0" : : "r" (app_reset_vector));
    }
}

int main()
{
    /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
    HAL_Init();
    return 0;
}