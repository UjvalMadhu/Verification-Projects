'''
///////////////////////////////////////////////////////////////////////////////////
///                       Cocotb Verification Project                           ///
///                         4-bit Ripple Carry Adder                            ///
///////////////////////////////////////////////////////////////////////////////////
///   Test Bench: Self Checking                                                 ///
///   Copyright 2025 Ujval Madhu, All rights reserved                           ///
///////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: rca4b_tb.sv 1.0
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
from cocotb.utils import get_sim_time

@cocotb.test()
async def test(dut):
    error_count = 0
    logging.getLogger().setLevel(logging.INFO)

    for i in range(30):   
        # Randomization
        a = random.randint(0,15)
        b = random.randint(0,15)
        cin  = random.randint(0,1)
        
        # Assigning DUT Signal values 
        dut.a.value = a
        dut.b.value = b
        dut.cin.value = cin 

        await Timer(10, 'ns')

        # Reading and Monitoring Values
        sout = dut.sum.value.integer
        cout = dut.cout.value.integer

        exp_sum = a + b + cin
        if(cout): sum = 16 + sout
        else: sum = sout

        if(exp_sum != sum):
            error_count+=1
            print('Error Occurred at: ', get_sim_time('ns'), 'ns')

        print('DUT a:', dut.a.value, ', DUT b: ', dut.b.value,', DUT cin: ', dut.cin.value, ' DUT Sum :', dut.sum.value, ', DUT Cout: ',dut.cout.value)
        print('DUT Sum Value:',sum, ', Exp Sum: ',exp_sum)
            
        await Timer(10, 'ns')
   
    # Printing Results
   
    print('------------------------------------------------')
    
    if(error_count > 0):
        logging.error('Number of Errors found %d', error_count)
    
    else:
        logging.info('All Test Cases Passed')
    
    print('------------------------------------------------')