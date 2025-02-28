'''
///////////////////////////////////////////////////////////////////////////////////
///                       Cocotb Verification Project                           ///
///                           Priority Encoder                                  ///
///////////////////////////////////////////////////////////////////////////////////
///   Testbench : Checks the DUT output with a Python Functional Model          ///
///   Randomized Stimulus Generation is also implemented                        ///
///   We implement the testbench using binary values                            ///
///   but, can directly use python integer values                               /// 
///   Acknowledgement: Kumar Khandagle, namaste-fpga.com                        ///
///   Copyright 2025 Ujval Madhu, All rights reserved                           ///
///////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: pr_enc_tb.py,v 1.0
//
//  $Date: 2025-27-02
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu
'''
import cocotb
import logging
import random

from cocotb.triggers import Timer
from cocotb.utils import get_sim_time
from cocotb.binary import BinaryValue

# Reference Model
def dut_model(din, en):

    if (en):
        if(din.binstr[0] == '1'):
            exp_val = '111'
        elif(din.binstr[1] == '1'):
            exp_val = '110'
        elif(din.binstr[2] == '1'):
            exp_val = '101'
        elif(din.binstr[3] == '1'):
            exp_val = '100'
        elif(din.binstr[4] == '1'):
            exp_val = '011'
        elif(din.binstr[5] == '1'):
            exp_val = '010'
        elif(din.binstr[6] == '1'):
            exp_val = '001'
        elif(din.binstr[7] == '1'):
            exp_val = '000'
    else:
        exp_val = '000'
    return exp_val

# CocoTB Test bench
@cocotb.test()

async def test(dut):

    error_count = 0              # To keep track of errors
    logging.getLogger().setLevel(logging.INFO)

    input_bin = BinaryValue(value = 0, n_bits = 8, bigEndian= False)
    output_bin = BinaryValue(0, 3, False)

    for i in range(30):
        input_rand = random.randint(0,255)
        input_bin.integer = input_rand

        enable         = random.randint(0,1)        # Setting Enable signal to 1 or 0
        dut.en.value   = enable
        dut.din.value  = input_rand

        model_out = dut_model(input_bin, enable)           # Model Compute

        await Timer(10, 'ns')

        output_bin.integer = dut.out.value

        print('Input: ', dut.din.value, ', Output: ',output_bin.binstr, ', Ref Data: ',model_out, ', DUT en:', dut.en.value)

        if(model_out != output_bin.binstr):
            error_count+=1
            print('Error Occurred at: ', get_sim_time('ns'), 'ns')
        
        await Timer(10, 'ns')

   
   
    # Printing Results
   
    print('------------------------------------------------')
    
    if(error_count > 0):
        logging.error('Number of Errors found %d', error_count)
    
    else:
        logging.info('All Test Cases Passed')
    
    print('------------------------------------------------')

