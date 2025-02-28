'''
///////////////////////////////////////////////////////////////////////////////////
///                       Cocotb Verification Project                           ///
///                               8x1 MUX                                       ///
///////////////////////////////////////////////////////////////////////////////////
///   Test Bench : Randomized Stimulus                                          ///
///   Acknowledgement: Kumar Khandagle, namaste-fpga.com                        ///
///   Copyright 2025 Ujval Madhu, All rights reserved                           ///
///////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: mux8x1.py,v 1.0
//
//  $Date: 2025-28-02
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu
'''

import cocotb 
import logging
import random

from cocotb.triggers import Timer
from cocotb.binary import BinaryValue

@cocotb.test()
async def test(dut):
    error_count = 0
    logging.getLogger().setLevel(logging.INFO)

    din_bin = BinaryValue(value = 0, n_bits = 8, bigEndian = False)
    sel_bin = BinaryValue(0,4,False)

    for i in range(30):   
        # Randomization
        din = random.randint(0,255)
        sel = random.randint(0,7)
        en  = random.randint(0,1)
        
        # Assigning DUT Signal values 
        dut.en.value = en
        dut.din.value = din
        dut.sel.value = sel 

        await Timer(10, 'ns')

        # Reading and Monitoring Values
        din_bin.integer = din
        sel_bin.integer = sel
        dout = dut.dout.value

        if(en): exp_dout = din_bin.binstr[7-sel]
        else: exp_dout = 0

        if(exp_dout != dout):
            error_count+=1
            print('Error Occurred at: ', get_sim_time('ns'), 'ns')

        print('DUT en:', dut.en.value, ', Input: ', dut.din.value, 'Sel: ', dut.sel.value, ', DUT Output: ',dout, ', Exp Out: ',exp_dout)
            
        await Timer(10, 'ns')
   
    # Printing Results
   
    print('------------------------------------------------')
    
    if(error_count > 0):
        logging.error('Number of Errors found %d', error_count)
    
    else:
        logging.info('All Test Cases Passed')
    
    print('------------------------------------------------')