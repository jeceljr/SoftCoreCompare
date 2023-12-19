# SoftCoreCompare

Running the program SoftCoreCompare.py will eventually use a dialog box to select a
number of various RISC-C and other small soft cores to be compared  when synthesized
by Yosys to several FPGAs (and later translated into just NAND gates and also into
chip layouts by OpenLane 2).

The *defaults.json* file, if present, can be used to have some FPGAs and some
soft core projects initially deselected. This can be changed when using the
program, so it just speeds up a little in the case where the same configuration
is often used.

Once the data is collected there will be options for generating reports in the form
of LaTex compatible tables and graphs.

The same *defaults.json* file can also list a series of reports which can be
automatically generated all at once or interactively one at a time. Creating
a completely new report is an option at any time.

## License

While the "MIT license" is used for the original material in this project, each soft
core is in the form of Verilog files copied (and sometimes slightly patched) from
various projects. These files use the license of the project they came from.

## Dependencies

Python 3 must be installed in the user's machine. The program uses the Tkinter
package for the user interface elements. This is supposed to be included in
Python installations, but in many cases it is not and must be explicitly
downloaded.

[Yosys](https://github.com/YosysHQ/yosys.git) must be installed and running
correctly since it is invoked by the program to synthesize each project for
each FPGA to collected the desired statistics.

Yosys needs two files from the [OnlyNandYosysSynth](https://github.com/OuDret/OnlyNandYosysSynth.git)
to be able to convert the soft cores to NAND gates, which is a good proxy of the
complexity of the circuits when implemented as integrated circuits. Files
*cells.lib* and *all2nand.v* were copied from the directory *OnlyNandYosysSynth/*.

## FPGAS

### ICE40

### ECP5

### Gowin

### Cyclone V

### Xilinx 7

## NANDs

## ASIC

## RISC-V Soft Cores

The rise of the RISC-V instruction set open standard has encouraged many
different groups to implement soft cores compatible with the standard.
Just because the standard is open doesn't mean that any given core is also
open, but the ones in this study are.

In addition, only cores implemented in Verilog or the subset of System Verilog
handled by Yosys were considered. RISC-V cores have a tremendous range in
performance and complexity, from tiny 32 bit microcotrollers to out-of-order
64 bit application cores for datacenters. Only the low end was studied here.

### Glacial

Glacial trades off performance for size by actually being an 8 bit processor which
emulates a 32 bit RISC-V. One inspiration was the low end of the original IBM S/360
family which used microcode and an 8 bit datapath to implement the architecture.

The Verilog files were copied from [the original repository](https://github.com/brouhaha/glacial.git)
in the *verilog/* directory.

### SERV

SERV (SErial Risc V) also trades off performance for size, in this case by
having a completely serial implementation. This means that any operations
requires 32 clock cycles as the operation handles only a single bit in each
cycle. Serial computers were a little more common in the days of vacuum tubes
when every single component had a significant cost and added to the construction
cost as well. They became far rarer in the integrated circuit days, but are
one way to save FPGA resources best left for other parts of a project.

The Verilog files were copied from [the original repository](https://github.com/olofk/serv.git)
in the *rtl/* directory.

### PicoRV32

An early compact RISC-V core, the goal of the PicoRV32 was to fit in the tiny
ICE40 FPGAs first targetted by the ICE Storm open source FPGA tool, of which
Yosys was a key component.

The Verilog files were copied from [the original repository](https://github.com/YosysHQ/picorv32.git)
in the top directory.

### VexRiscv

[VexRiscv in SpinalHDL](https://github.com/SpinalHDL/VexRiscv.git) is meant to show
off the advantages of using that language, with many configuration options where
it is even easy to change the number of pipeline stages.

Many projects use the translated Verilog version of the processor, like the
management system in the [repository for Global Foundaries 180nm](https://github.com/efabless/caravel_mgmt_soc_gf180mcu.git)
version of the Caravel "harness" for open source ASIC design. The Verilog file was
copied from the *verilog/rtl/* directory.

### DarkRiscv

The original DarkRiscv was created in a single night of development to evaluate
the advantages and disadvantages of the RISC-V instruction set compared to others.
It can be optionally made smaller by reducing the number of registers as per RV32E.

The Verilog file was copied from [the original repository](https://github.com/darklife/darkriscv.git)
in the *rtl/* directory.

## Other Soft Cores

Even with all variation possible with the RISC-V instruction set, there are
applications where other designs are a better option. That is particularly
true when executing programs.

### MCPU

With only 4 instructions and addressing only 64 bytes of memory, the MCPU is
very small and yet is Turing complete.

The Verilog file was copied from [the original repository](https://github.com/cpldcpu/MCPU.git)
in the *verilog/* directory.

### Fento 16

In the [8 Bit Workshop](http://8bitworkshop.com/) online videogame development system
there is an option to design games at the hardware level using Verilog. The examples
grow in complexity and two simple processors, the 8 bit Femto 8 and the 16 bit Femto 16,
are introduced and games are converted from pure hardware to assembly prograams for
them.

The Verilog file was copied from [the original repository](https://github.com/sehugg/8bitworkshop.git)
in the *presets/verilog/* directory.

### J0 

The [PDF describing the J1 soft core](https://excamera.com/files/j1.pdf) optimized for
small programs in the Forth language was the inspiration for projects like
[SwapForth](https://github.com/jamesbowman/swapforth) by the same author and
the [Forth CPU](https://github.com/howerj/forth-cpu) computer system.

The Gameduino project adds an FPGA based video output for Arduino boards and includes
the J0 processor, as slight modification of the J1.

The Verilog file was copied from [a fork of the original repository](https://github.com/Godzil/gameduino)
in the *fpga/* directory.

### ukp and 6502

A NES (Famicom) emulator for the Sipeed Tang Nano 20K FPGA board includes two processors.
The 6502 is needed to run the actual games while the limited ukp handles USB mice,
keyboards or game controllers.

The Verilog files were copied to the respective projects from
[the original repository](https://github.com/nand2mario/nestang.git)
in the *src/* directory.

### ZPU Avalanche

The ZPU was designed to use the least FPGA possible while being fully compatible
with all the GNU programming tools, including GCC. The idea is that on an FPGA
even C is more of a scripting language as the heavy processing will be done by
hardware blocks.

Th Avalanche project translated the original VHDL implementation to System Verilog.
The System Verilog files were copied from [the original repository](https://github.com/sergev/zpu-avalanche.git)
in the top directory.

### Baby 8
