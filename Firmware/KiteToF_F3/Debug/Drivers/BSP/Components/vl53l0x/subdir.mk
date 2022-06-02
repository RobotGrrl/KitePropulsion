################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (10.3-2021.10)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/BSP/Components/vl53l0x/vl53l0x_api.c \
../Drivers/BSP/Components/vl53l0x/vl53l0x_api_calibration.c \
../Drivers/BSP/Components/vl53l0x/vl53l0x_api_core.c \
../Drivers/BSP/Components/vl53l0x/vl53l0x_api_ranging.c \
../Drivers/BSP/Components/vl53l0x/vl53l0x_api_strings.c \
../Drivers/BSP/Components/vl53l0x/vl53l0x_platform_log.c 

OBJS += \
./Drivers/BSP/Components/vl53l0x/vl53l0x_api.o \
./Drivers/BSP/Components/vl53l0x/vl53l0x_api_calibration.o \
./Drivers/BSP/Components/vl53l0x/vl53l0x_api_core.o \
./Drivers/BSP/Components/vl53l0x/vl53l0x_api_ranging.o \
./Drivers/BSP/Components/vl53l0x/vl53l0x_api_strings.o \
./Drivers/BSP/Components/vl53l0x/vl53l0x_platform_log.o 

C_DEPS += \
./Drivers/BSP/Components/vl53l0x/vl53l0x_api.d \
./Drivers/BSP/Components/vl53l0x/vl53l0x_api_calibration.d \
./Drivers/BSP/Components/vl53l0x/vl53l0x_api_core.d \
./Drivers/BSP/Components/vl53l0x/vl53l0x_api_ranging.d \
./Drivers/BSP/Components/vl53l0x/vl53l0x_api_strings.d \
./Drivers/BSP/Components/vl53l0x/vl53l0x_platform_log.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/BSP/Components/vl53l0x/%.o Drivers/BSP/Components/vl53l0x/%.su: ../Drivers/BSP/Components/vl53l0x/%.c Drivers/BSP/Components/vl53l0x/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F303xC -c -I../Core/Inc -I../Drivers/STM32F3xx_HAL_Driver/Inc -I../Drivers/STM32F3xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F3xx/Include -I../Drivers/CMSIS/Include -I../Drivers/BSP/Components/Common -I../Drivers/BSP/Components/vl53l0x -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-BSP-2f-Components-2f-vl53l0x

clean-Drivers-2f-BSP-2f-Components-2f-vl53l0x:
	-$(RM) ./Drivers/BSP/Components/vl53l0x/vl53l0x_api.d ./Drivers/BSP/Components/vl53l0x/vl53l0x_api.o ./Drivers/BSP/Components/vl53l0x/vl53l0x_api.su ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_calibration.d ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_calibration.o ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_calibration.su ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_core.d ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_core.o ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_core.su ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_ranging.d ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_ranging.o ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_ranging.su ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_strings.d ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_strings.o ./Drivers/BSP/Components/vl53l0x/vl53l0x_api_strings.su ./Drivers/BSP/Components/vl53l0x/vl53l0x_platform_log.d ./Drivers/BSP/Components/vl53l0x/vl53l0x_platform_log.o ./Drivers/BSP/Components/vl53l0x/vl53l0x_platform_log.su

.PHONY: clean-Drivers-2f-BSP-2f-Components-2f-vl53l0x

