import cocotb
import logging

from cocotb.triggers import Timer
from cocotb.utils import get_sim_time

# Manual Creation of a clock signal with 75% Duty cycle
async def clk1(dut):
    ton  = 7.5
    toff = 2.5

    while True:
        dut.clk1.value = 1
        await Timer(ton,'ns')
        dut.clk1.value = 0
        await Timer(toff, 'ns')

# Clock generation with Phase Shift
async def clk2(dut):
    ton = 10
    toff = 10
    phShift = 5

    dut.clk2.value = 0
    await Timer(phShift, 'ns')

    while True:
        dut.clk2.value = 1
        await Timer(ton, 'ns')
        dut.clk2.value = 0
        await Timer(toff, 'ns')

# Creation of Clock for a given Frequency and Duty Cycle
async def clk3(dut):
    freq = 1e8 # 100 MHz = 1/10 ns
    phShift = 2
    dutyCycle = 0.3

    ton = (1/freq) * dutyCycle * 1e9  #ns

    toff = (1e9/freq) - ton

    logging.getLogger().setLevel(logging.INFO)
    logging.info(f"Freq(MHz): {freq/1e6}, Phase Shift(ns): {phShift}, Duty Cycle(%): {dutyCycle*100}, TON(ns): {ton}, TOFF(ns): {toff}")

    dut.clk3.value = 0
    await Timer(phShift, 'ns')

    while True:
        dut.clk3.value = 1
        await Timer(ton, 'ns')
        dut.clk3.value = 0
        await Timer(toff, 'ns')

@cocotb.test()
async def test(dut):
    cocotb.start_soon(clk1(dut))
    cocotb.start_soon(clk2(dut))
    cocotb.start_soon(clk3(dut))

    await Timer (200, 'ns')