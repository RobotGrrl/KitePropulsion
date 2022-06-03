/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2022 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "vl53l0x_api.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
#define ERR_DETECT             -1
/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
 I2C_HandleTypeDef hi2c2;

/* USER CODE BEGIN PV */

/**
 * Global ranging struct
 */
VL53L0X_RangingMeasurementData_t RangingMeasurementData;

/** leaky factor for filtered range
 *
 * r(n) = averaged_r(n-1)*leaky +r(n)(1-leaky)
 *
 * */
int LeakyFactorFix8 = (int)( 0.6 *256);

/** How many device detect set by @a DetectSensors()*/
int nDevPresent=0;

/** bit is index in VL53L0XDevs that is not necessary the dev id of the BSP */
int nDevMask;
// EK ^ that is probably not needed after removing the for loop completely

VL53L0X_Dev_t VL53L0XDev = {
		.Id=0,
		.DevLetter='e',
		.I2cHandle=&hi2c2, // TODO: I2C_HandleTypeDef
		.I2cDevAddr=0x29 // EK: documentation says address is 0x29, why did the code say 0x52?
};

int range;
int range_mm;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_I2C2_Init(void);
/* USER CODE BEGIN PFP */

void ResetAndDetectSensor(int SetDisplay); // TODO: add this function

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/**
 * Handle Error
 *
 * Set err on display and loop forever
 * @param err Error case code
 */
void HandleError(int err){
    char msg[16];
    sprintf(msg,"Er%d", err);
    while(1){};
}

/**
 * Reset all sensor then do presence detection
 *
 * All present devices are data initiated and assigned to their final I2C address
 * @return
 */
int DetectSensors(int SetDisplay) {
    int i;
    uint16_t Id;
    int status;
    int FinalAddress;

    // EK unused char PresentMsg[5]="    ";
    /* Reset all */
    nDevPresent = 0;

    // EK: commenting this out, unclear if it's needed w/o an i2c expander
    /*
    for (i = 0; i < 3; i++)
        status = XNUCLEO53L0A1_ResetId(i, 0);
    */
    // EK: this function is in the HAL for that nucleo board
    // why would it be located there if it is for the sensor?
    // what is that code doing - something about an expander? why?

    /* detect all sensors (even on-board)*/
    // EK no need for for loop for (i = 0; i < 3; i++) {

    i = 0; // EK: in case anything is out there using i

    		VL53L0X_Dev_t *pDev;
        pDev = &VL53L0XDev; // EK: only using one //&VL53L0XDevs[i];
        pDev->I2cDevAddr = 0x29; // EK: documentation says address is 0x29, why did the code say 0x52? //0x52;
        pDev->Present = 0;
        status = 1; // EK: is this needed? XNUCLEO53L0A1_ResetId( pDev->Id, 1);
        HAL_Delay(2); // EK: why is this here
        FinalAddress= 0x29; // EK: see comment a few lines above about address // 0x52+(i+1)*2;

        do {
        	/* Set I2C standard mode (400 KHz) before doing the first register access */
        	// EK: why is this, just do it  if (status == VL53L0X_ERROR_NONE)
        	// EK let's not do this status = VL53L0X_WrByte(pDev, 0x88, 0x00);

        	/* Try to read one register using default 0x52 address */
            status = VL53L0X_RdWord(pDev, VL53L0X_REG_IDENTIFICATION_MODEL_ID, &Id);
            if (status) {
                printf("#%d Read id fail\n", i);
                break;
            }
            if (Id == 0xEEAA) {
				/* Sensor is found => Change its I2C address to final one */
                status = VL53L0X_SetDeviceAddress(pDev,FinalAddress);
                if (status != 0) {
                    printf("#%d VL53L0X_SetDeviceAddress fail\n", i);
                    break;
                }
                pDev->I2cDevAddr = FinalAddress;
                /* Check all is OK with the new I2C address and initialize the sensor */
                status = VL53L0X_RdWord(pDev, VL53L0X_REG_IDENTIFICATION_MODEL_ID, &Id);
                if (status != 0) {
					printf("#%d VL53L0X_RdWord fail\n", i);
					break;
				}

                status = VL53L0X_DataInit(pDev);
                if( status == 0 ){
                    pDev->Present = 1;
                }
                else{
                    printf("VL53L0X_DataInit %d fail\n", i);
                    break;
                }
                printf("VL53L0X %d Present and initiated to final 0x%x\n", pDev->Id, pDev->I2cDevAddr);
                nDevPresent++;
                nDevMask |= 1 << i;
                pDev->Present = 1;
            }
            else {
                printf("#%d unknown ID %x\n", i, Id);
                status = 1;
            }
        } while (0);
        /* if fail r can't use for any reason then put the  device back to reset */
        if (status) {
        	  printf("something failed"); // EK
            // EK why is this needed XNUCLEO53L0A1_ResetId(i, 0);
        }

    // EK no need for for loop }

    // EK: not needed
    /* Display detected sensor(s) */
    /*
    if( SetDisplay ){
        for(i=0; i<3; i++){
            if( VL53L0XDevs[i].Present ){
                PresentMsg[i+1]=VL53L0XDevs[i].DevLetter;
            }
        }
        PresentMsg[0]=' ';
        XNUCLEO53L0A1_SetDisplayString(PresentMsg);
        HAL_Delay(1000);
    }
    */

    return nDevPresent;
}

void ResetAndDetectSensor(int SetDisplay){
    int nSensor;
    nSensor = DetectSensors(SetDisplay);

    // EK added this
    if( VL53L0XDev.Present==0 )
    {
    	HandleError(ERR_DETECT);
    }

    /* at least one sensor and if one it must be the built-in one  */
    if( (nSensor <=0) ) { // EK ||  (nSensor ==1 && VL53L0XDevs[1].Present==0) ){
        HandleError(ERR_DETECT);
    }
}

VL53L0X_Error WaitStopCompleted(VL53L0X_DEV Dev) {
    VL53L0X_Error Status = VL53L0X_ERROR_NONE;
    uint32_t StopCompleted=0;
    uint32_t LoopNb;

    // Wait until it finished
    // use timeout to avoid deadlock
    if (Status == VL53L0X_ERROR_NONE) {
        LoopNb = 0;
        do {
            Status = VL53L0X_GetStopCompletedStatus(Dev, &StopCompleted);
            if ((StopCompleted == 0x00) || Status != VL53L0X_ERROR_NONE) {
                break;
            }
            LoopNb = LoopNb + 1;
            VL53L0X_PollingDelay(Dev);
        } while (LoopNb < VL53L0X_DEFAULT_MAX_LOOP);

        if (LoopNb >= VL53L0X_DEFAULT_MAX_LOOP) {
            Status = VL53L0X_ERROR_TIME_OUT;
        }

    }

    return Status;
}

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_I2C2_Init();
  /* USER CODE BEGIN 2 */


  //ResetAndDetectSensor(1); // EK TODO: the parameter SetDisplay doesn't matter

  // EK test1
  HAL_StatusTypeDef status;
	uint8_t pData;
	status = HAL_I2C_Mem_Read(&hi2c2, 0x52, 0xC0, 1, &pData, 1, HAL_TIMEOUT);
	// pData should be 0xEE
	if(status == HAL_OK) {
		printf("good");
	}
	//--

  // EK test2
  VL53L0X_Dev_t *pDev;
	pDev = &VL53L0XDev;
	pDev->I2cDevAddr = 0x52;
	pDev->Present = 0;

  int status2 = VL53L0X_DataInit(pDev);
	if( status2 == 0 ){
			pDev->Present = 1;
	}
	else{
			printf("VL53L0X_DataInit fail\n");
	}
	printf("VL53L0X %d Present and initiated to final 0x%x\n", pDev->Id, pDev->I2cDevAddr);
	pDev->Present = 1;
	//--

	// EK test3
	uint8_t VhvSettings;
	uint8_t PhaseCal;
	uint32_t refSpadCount;
	uint8_t isApertureSpads;
	VL53L0X_RangingMeasurementData_t RangingMeasurementData;
	//int range;

	// Initialize the device in continuous ranging mode
	VL53L0X_StaticInit(pDev);
	VL53L0X_PerformRefCalibration(pDev, &VhvSettings, &PhaseCal);
	VL53L0X_PerformRefSpadManagement(pDev, &refSpadCount, &isApertureSpads);
	//VL53L0X_SetInterMeasurementPeriodMilliSeconds(pDev, 250); // Program continuous mode Inter-Measurement period in milliseconds
	//VL53L0X_SetDeviceMode(pDev, VL53L0X_DEVICEMODE_CONTINUOUS_RANGING);
	VL53L0X_SetInterMeasurementPeriodMilliSeconds(pDev, 100);
	VL53L0X_SetDeviceMode(pDev, VL53L0X_DEVICEMODE_CONTINUOUS_TIMED_RANGING);

	// Start continuous ranging
	VL53L0X_StartMeasurement(pDev);

	/*
	for(uint8_t i=0; i<5; i++) {
		VL53L0X_GetRangingMeasurementData(pDev, &RangingMeasurementData);
		range = (int)RangingMeasurementData.RangeMilliMeter/10;
		HAL_Delay(100);
	}

	// Stop continuous ranging
	VL53L0X_StopMeasurement(pDev);

	// Ensure device is ready for other commands
	WaitStopCompleted(pDev);
	*/
	//--



  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {

  	VL53L0X_GetRangingMeasurementData(pDev, &RangingMeasurementData);
		range = (int)RangingMeasurementData.RangeMilliMeter/10; // cm
		range_mm = (int)RangingMeasurementData.RangeMilliMeter; // mm
		//HAL_Delay(1000);

    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};
  RCC_PeriphCLKInitTypeDef PeriphClkInit = {0};

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
  RCC_OscInitStruct.PLL.PLLMUL = RCC_PLL_MUL12;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_1) != HAL_OK)
  {
    Error_Handler();
  }
  PeriphClkInit.PeriphClockSelection = RCC_PERIPHCLK_I2C2;
  PeriphClkInit.I2c2ClockSelection = RCC_I2C2CLKSOURCE_HSI;
  if (HAL_RCCEx_PeriphCLKConfig(&PeriphClkInit) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief I2C2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_I2C2_Init(void)
{

  /* USER CODE BEGIN I2C2_Init 0 */

  /* USER CODE END I2C2_Init 0 */

  /* USER CODE BEGIN I2C2_Init 1 */

  /* USER CODE END I2C2_Init 1 */
  hi2c2.Instance = I2C2;
  hi2c2.Init.Timing = 0x2000090E;
  hi2c2.Init.OwnAddress1 = 0;
  hi2c2.Init.AddressingMode = I2C_ADDRESSINGMODE_7BIT;
  hi2c2.Init.DualAddressMode = I2C_DUALADDRESS_DISABLE;
  hi2c2.Init.OwnAddress2 = 0;
  hi2c2.Init.OwnAddress2Masks = I2C_OA2_NOMASK;
  hi2c2.Init.GeneralCallMode = I2C_GENERALCALL_DISABLE;
  hi2c2.Init.NoStretchMode = I2C_NOSTRETCH_DISABLE;
  if (HAL_I2C_Init(&hi2c2) != HAL_OK)
  {
    Error_Handler();
  }

  /** Configure Analogue filter
  */
  if (HAL_I2CEx_ConfigAnalogFilter(&hi2c2, I2C_ANALOGFILTER_ENABLE) != HAL_OK)
  {
    Error_Handler();
  }

  /** Configure Digital filter
  */
  if (HAL_I2CEx_ConfigDigitalFilter(&hi2c2, 0) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN I2C2_Init 2 */

  /* USER CODE END I2C2_Init 2 */

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOE_CLK_ENABLE();
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOF_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOE, CS_I2C_SPI_Pin|LD4_Pin|LD3_Pin|LD5_Pin
                          |LD7_Pin|LD9_Pin|LD10_Pin|LD8_Pin
                          |LD6_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pins : DRDY_Pin MEMS_INT3_Pin MEMS_INT4_Pin MEMS_INT1_Pin
                           MEMS_INT2_Pin */
  GPIO_InitStruct.Pin = DRDY_Pin|MEMS_INT3_Pin|MEMS_INT4_Pin|MEMS_INT1_Pin
                          |MEMS_INT2_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_EVT_RISING;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOE, &GPIO_InitStruct);

  /*Configure GPIO pins : CS_I2C_SPI_Pin LD4_Pin LD3_Pin LD5_Pin
                           LD7_Pin LD9_Pin LD10_Pin LD8_Pin
                           LD6_Pin */
  GPIO_InitStruct.Pin = CS_I2C_SPI_Pin|LD4_Pin|LD3_Pin|LD5_Pin
                          |LD7_Pin|LD9_Pin|LD10_Pin|LD8_Pin
                          |LD6_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOE, &GPIO_InitStruct);

  /*Configure GPIO pin : B1_Pin */
  GPIO_InitStruct.Pin = B1_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(B1_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pins : SPI1_SCK_Pin SPI1_MISO_Pin SPI1_MISOA7_Pin */
  GPIO_InitStruct.Pin = SPI1_SCK_Pin|SPI1_MISO_Pin|SPI1_MISOA7_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  GPIO_InitStruct.Alternate = GPIO_AF5_SPI1;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pins : DM_Pin DP_Pin */
  GPIO_InitStruct.Pin = DM_Pin|DP_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH;
  GPIO_InitStruct.Alternate = GPIO_AF14_USB;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pins : I2C1_SCL_Pin I2C1_SDA_Pin */
  GPIO_InitStruct.Pin = I2C1_SCL_Pin|I2C1_SDA_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_OD;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  GPIO_InitStruct.Alternate = GPIO_AF4_I2C1;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
