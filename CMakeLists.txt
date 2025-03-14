cmake_minimum_required(VERSION 3.22)
include(cmake/common/out_of_source.cmake)
include(cmake/common/helper_func.cmake)
include(cmake/cross_compile/toolchain_file.cmake)
include(cmake/common/custom_build_type.cmake)
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install CACHE INTERNAL "Install path")
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

set(SDK_PATH ${CMAKE_SOURCE_DIR})

set(PROJECT_NAME "a" CACHE STRING "Project Name")
project($CACHE{PROJECT_NAME}
	VERSION 0.1.0
	DESCRIPTION $CACHE{PROJECT_NAME}
	LANGUAGES C ASM
)

set(compile_options_common
	-Wall -Werror -Wno-unused-variable -Wno-unused-function
	-ffunction-sections -fdata-sections

    -DSTM32F410Rx -DUSE_HAL_DRIVER
    -I${SDK_PATH}/STM32F4xx_HAL_Driver/Inc
    -I${SDK_PATH}/STM32F4xx_HAL_Driver/Inc/Legacy
	-I${SDK_PATH}/CMSIS/Device/ST/STM32F4xx/Include
	-I${SDK_PATH}/CMSIS/Include
)

set(compile_options_arch 
    -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard
)

set(link_options_common
    ${compile_options_arch}
	-static
	# -nostdlib # we will explicitly link libc.a, libm.a and libgcc.a 
    --specs=nano.specs
	-Wl,--fatal-warnings
	-Wl,--gc-sections
	-Wl,-Map=${CMAKE_CURRENT_BINARY_DIR}/$CACHE{PROJECT_NAME}.map
	-Wl,--print-memory-usage
	$<$<NOT:$<CONFIG:Debug,RelWithDebInfo>>:-Wl,--strip-all>
)

if(${IS_GCC})
	### With ld.bfd version 2.39 and newer new warnings are added. 
	### Skip those since we are not loaded by a elf loader.
	if(${CMAKE_C_COMPILER_VERSION} VERSION_GREATER_EQUAL 12.2.0)
		set(link_options_common ${link_options_common} -Wl,--no-warn-rwx-segments)
	endif()
	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105523
	set(compile_options_common --param=min-pagesize=0 ${compile_options_common})
endif()

add_compile_options(${compile_options_arch} ${compile_options_common})

set_non_empty_cache(APP_CMAKE "" FILEPATH "Path to the app.cmake") # set APP_CMAKE default value to empty string, so that it must be provided by the user
include($CACHE{APP_CMAKE})
add_executable($CACHE{PROJECT_NAME}.elf)

target_sources($CACHE{PROJECT_NAME}.elf
	PRIVATE
		${app_src}
)

target_include_directories($CACHE{PROJECT_NAME}.elf
    PRIVATE
        ${app_inc}
)

target_compile_options($CACHE{PROJECT_NAME}.elf
	PRIVATE
		${app_compile_options}
)

target_link_options($CACHE{PROJECT_NAME}.elf
	PRIVATE
		${link_options_common}
        ${app_link_options}
)

target_link_libraries($CACHE{PROJECT_NAME}.elf
	PRIVATE
		${app_dep}
)

# Cumtom targets

## dump
add_custom_command(
	TARGET $CACHE{PROJECT_NAME}.elf POST_BUILD
	COMMAND ${CMAKE_OBJDUMP} -dx $CACHE{PROJECT_NAME}.elf > $CACHE{PROJECT_NAME}.dump
	WORKING_DIRECTORY   "${CMAKE_BINARY_DIR}"
)

## bin
add_custom_command(
	TARGET $CACHE{PROJECT_NAME}.elf POST_BUILD
	COMMAND ${CMAKE_OBJCOPY} -O binary $CACHE{PROJECT_NAME}.elf $CACHE{PROJECT_NAME}.bin
	WORKING_DIRECTORY   "${CMAKE_BINARY_DIR}"
)

# additional clean files
set_property(TARGET $CACHE{PROJECT_NAME}.elf 
	APPEND PROPERTY 
	ADDITIONAL_CLEAN_FILES 
		$CACHE{PROJECT_NAME}.map
		$CACHE{PROJECT_NAME}.bin
		$CACHE{PROJECT_NAME}.dump
)
