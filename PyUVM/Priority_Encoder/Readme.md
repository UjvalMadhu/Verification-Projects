# Priority Encoder Project

The Project aims to design a simple Big endian Priority Encoder and verify it using a cocotb testbench with randomized stimulus


## Description

- DUT Priority Encoder: 
This is a big-endian priority encoder that identifies the position of the most significant '1' bit in an 8-bit input. When enabled, it outputs a 3-bit value indicating the position (0-7) of the leftmost '1' bit. The highest bit (bit 7) has the highest priority, and the lowest bit (bit 0) has the lowest priority. If no bits are set or the enable signal is low, the output defaults to 0.

- Testbench: 
This testbench evaluates a priority encoder by running 30 randomized test cases that compare hardware outputs to a software reference model.
For each test, it:

1. Generates a random 8-bit input and random enable signal
2. Applies these to both the DUT and a reference model function
3. Waits 10ns for the hardware to respond
4. Compares the actual output with the expected output
5. Logs any discrepancies with timestamps
6. Reports a final pass/fail summary with error count

The reference model implements the same big-endian priority encoding algorithm in software, but uses little-endian binary representation (note the bigEndian=False parameter),this is why the bit indices in the model appear reversed compared to the hardware implementation.



### Program Structure:


- pr_enc.sv    (DUT definition)
- pr_enc_tb.py (Python based testbench using cocotb)
- Makefile     (Build automation)


## Build Process:

The Makefile sets up a cocotb simulation environment with these key configurations:

    - Using Icarus Verilog simulator to run SystemVerilog code
    - The RTL source being simulated is "clocks.sv"
    - The top-level module to test is named "top"
    - The Python testbench file is "clocks_tb.py"

The makefile leverages cocotb's built-in simulation framework by including the standard Makefile.sim, which provides all the compilation and simulation targets. You simply run make to execute the tests.

## Running the Simulation

```bash

make sim=icarus      # This compiles all the RTL code and the Python testbench and generates the dump.vcd waveform dump file

gtkwave dump.vcd     # GTWave opens the GUI and reads the generated waveform dump file

```
## Output Waveform

The output waveform obtained from GTKWave is as follows:
<p>
    <img = src = "./prc_enc_waveform.png">
</p>

## License

This project is licensed under the GNU General Public License, Version 3 - see the [LICENSE.md](../LICENSE.md) file for details.

## Contact

- Author: Ujval Madhu
- Email: ujvalmadhu003@gmail.com

## Acknowledgments

- This Project was done based on references provided from the online documentations of Cocotb and with the help of notes and tutorials from Kumar Khandagle [Kumar's website](https://namaste-fpga.com/#/)