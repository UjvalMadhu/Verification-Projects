import cocotb
import random
from cocotb.triggers import Timer
from cocotb.binary import BinaryValue
from cocotb.utils import get_sim_time
import logging
    
   
@cocotb.test()     
async def add_stimuli(dut):

        a_val = dut.a
        a_val.value = 12
        b_val = dut.b
        b_val.value = 15

        await Timer(10, units = 'ns')

        current_time = get_sim_time('ns')
        expected_sum = 27
        assert dut.sum.value == expected_sum, f"Error at {current_time}ns: sum={dut.sum.value}, expected={expected_sum}"

        a_val.value = 7
        b_val.value = 10

        await Timer(10, units = 'ns')

        current_time = get_sim_time('ns')
        expected_sum = 17
        assert dut.sum.value == expected_sum, f"Error at {current_time}ns: sum={dut.sum.value}, expected={expected_sum}"

        a_val.value = 8
        b_val.value = 3
        
        await Timer(10, units = 'ns')

        current_time = get_sim_time('ns')
        expected_sum = 11
        assert dut.sum.value == expected_sum, f"Error at {current_time}ns: sum={dut.sum.value}, expected={expected_sum}"

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