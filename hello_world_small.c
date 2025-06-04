/* 
 * "Small Hello World" example. 
 * 
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example 
 * designs. It requires a STDOUT  device in your system's hardware. 
 *
 * The purpose of this example is to demonstrate the smallest possible Hello 
 * World application, using the Nios II HAL library.  The memory footprint
 * of this hosted application is ~332 bytes by default using the standard 
 * reference design.  For a more fully featured Hello World application
 * example, see the example titled "Hello World".
 *
 * The memory footprint of this example has been reduced by making the
 * following changes to the normal "Hello World" example.
 * Check in the Nios II Software Developers Manual for a more complete 
 * description.
 * 
 * In the SW Application project (small_hello_world):
 *
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 * In System Library project (small_hello_world_syslib):
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 *    - Define the preprocessor option ALT_NO_INSTRUCTION_EMULATION 
 *      This removes software exception handling, which means that you cannot 
 *      run code compiled for Nios II cpu with a hardware multiplier on a core 
 *      without a the multiply unit. Check the Nios II Software Developers 
 *      Manual for more details.
 *
 *  - In the System Library page:
 *    - Set Periodic system timer and Timestamp timer to none
 *      This prevents the automatic inclusion of the timer driver.
 *
 *    - Set Max file descriptors to 4
 *      This reduces the size of the file handle pool.
 *
 *    - Check Main function does not exit
 *    - Uncheck Clean exit (flush buffers)
 *      This removes the unneeded call to exit when main returns, since it
 *      won't.
 *
 *    - Check Don't use C++
 *      This builds without the C++ support code.
 *
 *    - Check Small C library
 *      This uses a reduced functionality C library, which lacks  
 *      support for buffering, file IO, floating point and getch(), etc. 
 *      Check the Nios II Software Developers Manual for a complete list.
 *
 *    - Check Reduced device drivers
 *      This uses reduced functionality drivers if they're available. For the
 *      standard design this means you get polled UART and JTAG UART drivers,
 *      no support for the LCD driver and you lose the ability to program 
 *      CFI compliant flash devices.
 *
 *    - Check Access device drivers directly
 *      This bypasses the device file system to access device drivers directly.
 *      This eliminates the space required for the device file system services.
 *      It also provides a HAL version of libc services that access the drivers
 *      directly, further reducing space. Only a limited number of libc
 *      functions are available in this configuration.
 *
 *    - Use ALT versions of stdio routines:
 *
 *           Function                  Description
 *        ===============  =====================================
 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
 *        alt_putstr       Smaller overhead than puts with direct drivers
 *                         Note this function doesn't add a newline.
 *        alt_putchar      Smaller overhead than putchar with direct drivers
 *        alt_getchar      Smaller overhead than getchar with direct drivers
 *
 */

#include <stdio.h>
#include <unistd.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
#include "sys/alt_timestamp.h"

void delay_us(unsigned int microseconds)
{
    alt_u32 ticks_per_us = alt_timestamp_freq() / 1000000;
    alt_u32 end = alt_timestamp() + (ticks_per_us * microseconds);
    while (alt_timestamp() < end);
}

#define NEG_ENA_IN_POS  9
#define EQUAL_POS		10
#define ADD_POS 		5
#define SUBSTRACT_POS   6
#define MULTIPLY_POS 	7
#define DIVISION_POS    8

#define NEG_ENA_IN_MASK 1 << NEG_ENA_IN_POS
#define EQUAL_MASK		1 << EQUAL_POS
#define ADD_MASK		1 << ADD_POS
#define SUBSTRACT_MASK  1 << SUBSTRACT_POS
#define MULTIPLY_MASK   1 << MULTIPLY_POS
#define DIVISION_MASK	1 << DIVISION_POS

#define EXTRACT_BIT(num, mask, pos) ((num) & (mask)) >> (pos)
#define SET_BIT(num, pos) ((num) |= (1U << (pos)))

alt_16 extract_bits(alt_16 orig16BitWord, unsigned from, unsigned to)
{
  unsigned mask = ( (1<<(to-from+1))-1) << from;
  return (orig16BitWord & mask) >> from;
}

void set_neg(alt_16 num, alt_8 neg_in)
{
	if(neg_in == 1) num = -num;
}

int main()
{ 
  printf("Pomyslnie uruchomiono program\n");
  alt_u16 input;
  if(alt_timestamp_start() < 0)
  {
	  printf("Brak timera w systemie!\n");
	  return 1;
  }

  alt_8 op = 0;
  alt_8 add = 0;
  alt_8 substr = 0;
  alt_8 mult = 0;
  alt_8 div	= 0;
  alt_8 equal = 0;
  alt_8 neg_in = 0;
  alt_16 num1 = 0;
  alt_16 num2 = 0;
  alt_16 result = 0;

  while (1)
  {
	  num1 = IORD_ALTERA_AVALON_PIO_DATA(PIO_0_BASE);
	  add = EXTRACT_BIT(num1, ADD_MASK, ADD_POS);
	  substr = EXTRACT_BIT(num1, SUBSTRACT_MASK, SUBSTRACT_POS);
	  equal = EXTRACT_BIT(num1, EQUAL_MASK, EQUAL_POS);
	  neg_in = EXTRACT_BIT(num1, NEG_ENA_IN_MASK, NEG_ENA_IN_POS);
	  num1 = extract_bits(num1, 0, 4);

	  equal = -equal;
	  set_neg(num1, neg_in);

	  if(add == 1)
	  {
		  result = num1;
		  op = 1;
	  }
	  if(substr == 1)
	  {
		  result = num1;
		  op = 2;
	  }
	  if(mult == 1)
	  {
		  result = num1;
		  op = 3;
	  }
	  if(div == 1)
	  {
		  result = num1;
		  op = 4;
	  }

	  //printf("add=%d\n", result);
	  //printf("Equal=%d\n", equal);

	  if(equal == 0)
	  {
		  //printf("op=%d\n", op);
		  if(op > 0 && op < 5)
		  {
			  equal = 1;
			  num2 = IORD_ALTERA_AVALON_PIO_DATA(PIO_0_BASE);

			  num2 = extract_bits(num2, 0, 4);
			  set_neg(num2, neg_in);

			  if(op == 1) result += num2;
			  if(op == 2) result -= num2;
			  if(op == 3) result *= num2;
			  if(op == 4 && num2 != 0) result /= num2;
			  usleep(300000);
			  //printf("Result2222222222222=%d\n", result);
		  }
		  //usleep(1000000);
		  //usleep(1000000);
	  }
	  if(result < 0) SET_BIT(result, 10);
	  IOWR_ALTERA_AVALON_PIO_DATA(PIO_1_BASE, result);
  }

  return 0;
}
