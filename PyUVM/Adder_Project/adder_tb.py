import cocotb
import random
from cocotb.triggers import Timer
from cocotb.binary import BinaryValue
import logging
    
   
@cocotb.test()     
async def add_stimuli(dut):
          full = 0      
          
          while (full != 1):
               dut.addr.value = random.randint(0,15)
               dut.din.value = random.randint(0,15)
               await Timer(10, units = 'ns')
               full = dut.full.value