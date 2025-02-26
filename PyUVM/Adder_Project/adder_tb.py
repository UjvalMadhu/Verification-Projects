import cocotb
import random
from cocotb.triggers import Timer
from cocotb.binary import BinaryValue
import logging
    
   
@cocotb.test()     
async def add_stimuli(dut):

        a_val = dut.a
        a_val.value = 12
        b_val = dut.b
        b_val.value = 15

        await Timer(10, units = 'ns')

        # print('My Cocotb TB')
        # logging.getLogger().setLevel(logging.INFO)
        # logging.info('INFO message in Cocotb TB')
        # a = 10
        # logging.info('Value of a : %0s', bin(a))

        #   full = 0      
          
        #   while (full != 1):
        #        dut.addr.value = random.randint(0,15)
        #        dut.din.value = random.randint(0,15)
        #        await Timer(10, units = 'ns')
        #        full = dut.full.value