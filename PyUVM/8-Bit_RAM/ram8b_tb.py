'''
///////////////////////////////////////////////////////////////////////////////////
///                       Cocotb Verification Project                           ///
///                              8-Bit RAM                                      ///
///////////////////////////////////////////////////////////////////////////////////
///   Testbench : Self Checking,  Python Functional Model                       ///
///   Constrained Randomized Stimulus Generation                                ///
///   Acknowledgement: Kumar Khandagle, namaste-fpga.com                        ///
///   Copyright 2025 Ujval Madhu, All rights reserved                           ///
///////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: ram8b_tb.py,v 1.0
//
//  $Date: 2025-02-03
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu
'''
import cocotb
import logging
import random

from cocotb.triggers import Timer, ClockCycles, RisingEdge
from cocotb.utils import get_sim_time
from cocotb.binary import BinaryValue
from cocotb.clock import Clock

mem = {}                  # Creating a Dictionary model of the DUT Memory
err_count = 0             # Setting the Error Count
read_count = 0
write_count = 0
reset_count = 0


# Reset Logic

async def rst_gen(dut):

    global reset_count
    logging.info('Applying Reset to DUT @ %0s ns', str(get_sim_time('ns')))
    
    for i in range(16):
        mem.update({i:0})
    
    dut.rst_n.value = 0
    await Timer(100,'ns')
   
    dut.rst_n.value = 1
    reset_count += 1
    
    await ClockCycles(dut.clk, 2)
    
    logging.info('System reset done @ %0s ns', str(get_sim_time('ns')))
    #print('reset val: ',dut.rst_n.value)
    print(mem)


# Read - Write Logic

async def read_write(dut):
   
   #print('Entered Read Write Block, reset val: ',dut.rst_n.value)
   global read_count, write_count
   
   read_write = random.randint(0,1)
   
   if(dut.rst_n.value):
    if(read_write):
        logging.info('--------------------------')
        logging.info(' Writing Data to Memory')
        logging.info('--------------------------')

        writes = random.randint(0,15)

        for i in range(writes):
            # Random Data Generation
            din = random.randint(0,255)
            addr = random.randint(0,15)
            write_count += 1
            
            # Model Update
            mem.update({addr:din})

            # DUT Write
            dut.addr.value = addr
            dut.din.value  = din
            dut.wr_en.value = 1
            await ClockCycles(dut.clk, 2)
            dut.wr_en.value = 0
        
        logging.info('Write completed @ %s ns', str(get_sim_time('ns')))
        print(mem)
    
    else:
        logging.info('--------------------------')
        logging.info(' Reading Data from Memory')
        logging.info('--------------------------')

        reads = random.randint(0,15)

        for i in range(reads):
            # Random Data Generation
            addr = random.randint(0,15)
            read_count +=1

            # DUT Read
            dut.addr.value = addr
            dut.wr_en.value = 0
            await ClockCycles(dut.clk, 2)
            dout = dut.dout.value

            # Checking Read Value with Memory Model
            if(dout != mem.get(addr)):
                logging.info('Read Error Detected @ %s ns', str(get_sim_time('ns')))
                err_count +=1
        
        logging.info('Read completed @ %s ns', str(get_sim_time('ns')))


# CocoTB Test bench
@cocotb.test()

async def test(dut):

    logging.getLogger().setLevel(logging.INFO)

    # Clock Generation
    cocotb.start_soon(Clock(dut.clk, period=20,units='ns').start())
    
    # Initia Reset
    await rst_gen(dut)

    # Randomized Stimulus Generation
    for i in range(50):

        # Constrained Randomization of Reset

        rst_gen_choice = [0,1]
        rst_gen_weights = [0.9, 0.1]

        rst_gen_bool = random.choices(rst_gen_choice, weights = rst_gen_weights)[0]
        if(rst_gen_bool):
            await rst_gen(dut)
            print('Reset Done @', get_sim_time('ns')) 

        # Randomized Read and Write
        await read_write(dut)

    await Timer(2000, 'ns')

   
    # Printing Results
   
    print('------------------------------------------------')
    
    if(err_count > 0):
        logging.error('Number of Errors found %d', err_count)
    
    else:
        logging.info('All Test Cases Passed')
        logging.info(f'Total tests performed: Read: {read_count}, Write: {write_count}, Reset: {reset_count}')
    
    print('------------------------------------------------')