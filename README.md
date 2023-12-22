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
each FPGA to collected the desired statistics. Compiled with the default
configuration, Yosys didn't work from Python3 so in *Makefile* this line
was changed from 0: "ENABLE_PYOSYS := 1". The default installation put the
yosys-abc command in */usr/local/bin* but the synth_ice40 command looked for
it in */usr/bin* when called from Python (it worked in the Yosys command line).
Making a copy in */usr/bin* is not the right solution, but seems to work.

Yosys needs two files from the [OnlyNandYosysSynth](https://github.com/OuDret/OnlyNandYosysSynth.git)
to be able to convert the soft cores to NAND gates, which is a good proxy of the
complexity of the circuits when implemented as integrated circuits. Files
*cells.lib* and *all2nand.v* were copied from the directory *OnlyNandYosysSynth/*.

The [Open Lane 2](https://github.com/efabless/openlane2) tool is used to generate
chip layouts for each soft cores (making them into hard cores) so the resulting
area can be compared. There are several ways to install this, but only the option
using the Nix package tool has been tested in this project. The optional
[Volare](https://github.com/efabless/volare) PDK management system was used to
select the right version of the Skywater 130nm PDK to generate the hardware for
the cores.

## FPGAS

Field Programmable Gate Arrays can implement any digital circuit up to a size
that depends on the particular FPGA device. It is possible to start with a high
level description of a processor (using a hardware description language such as
Verilog, VHDL, Chisel, SpinalHDL and others) and have either an FPGA specific
tool or an open source one (for only a few different FPGAs) to translate that
into a netlist of the basic blocks implemented by the FPGAs. A placement tool
will assign each block in the design to a specific one in the FPGA such that
the next step, routing, works as well as possible. Routing uses the configurable
connection network in the FPGA (a little like early telephone exchange systems)
to actually connect the placed blocks. This is encoded into a "bit file" that
is loaded by the FPGA each time it is turned on to actually implement the
circuit.

In this comparison we only take into account how many of each of the basic
blocks of the FPGA a given soft core uses when its Verilog sources are
translated with the open source tool Yosys. The basic blocks are:

- LUT: LookUp Tables implement all of the logic in the FPGAs. They can be
classified by how many address lines they need. A LUT4 has 16 words of a
single bit each and needs 4 bit addresses. A LUT6 has 64 bits and needs
6 address lines. A larger LUT can always do the job of a smaller one by
either tying unused address lines to 0 or 1 or else duplicating the bits
such that the output doesn't depend on that address line. Several smaller
LUTs can be combined into one larger one and several FPGAs offer special
"mux" blocks to make this more efficient without using even more extra
LUTs.

- Registers: the LUTs are purely combinational circuits so having an
optional flip-flop circuit at its output allows sequential circuits to
be implemented. Normally one register is associated with one LUT, but
there tend to be some extra registers as part of the i/o pads.

- DSP: Digital Signal Processing blocks are hardware implementations of
multiplication circuits. Otherwise a very large number of LUTs would be
required to implement this operation (which has many more uses beyond
digital signal processing).

- distributed memory: each LUT is actually a very small Random Access
Memory (RAM) but is normally not changed after the initial configuration
when the FPGA is turned on. A little extra circuit can allow all of the
LUTs or some fraction of them to be used as actual read/write memories.

- block memory: the area needed to store a bit in a register or even in
a LUT is very large compared to a dedicated RAM circuit. Since the 1990s
FPGAs have included a number of memory blocks that can efficiently handle
a medium to large number of bits.

Other FPGA blocks include input and output buffers, clock buffers, carry
circuits to convert LUTs into adder circuits, the multiplexers already
mentioned for combining several small LUTs into one larger logical one
and a few that might be unique to each type of FPGAs. For a high level
comparison it doesn't make sense to count these.

### [ICE40](https://www.latticesemi.com/iCE40)

The startup Silicon Blue took advantage of the expiration of key FPGA
patents to introduce their own very basic offering. Their focus was on
smaller FPGAs with low cost and low energy requirements. They were bought
by Lattice Semiconductor and a second generation was designed moving from
the original 65nm process to a more modern 40nm further reducing the
energy use.

### [ECP5](https://www.latticesemi.com/en/Products/FPGAandCPLD/ECP5)

Al evolution of the earlier ECP, ECP2 and ECP3 FPGAs, this mid range
family is one of the lowest cost options with high speed serial interfaces.

### [Gowin](https://www.gowinsemi.com/en/)

This Chinese company was the first to have success with FPGAs in other
countries with many variations on the classic FPGAs. One unique feature
is the use of spare LUTs to help with the routing. How much this is used
varies from one project to the next and this is why the numbers are not
always relatively the same compared to other types of FPGAs.

### [Cyclone V](https://www.intel.com/content/www/us/en/products/details/fpga/cyclone/v.html)

The Cyclone family was the low end of Altera FPGAs and the V generation was
the last one released before Altera was bought by Intel.

### [Xilinx 7](https://docs.xilinx.com/v/u/en-US/7-series-product-selection-guide)

The 28nm generation of Xilinx FPGas is still very popular even after it was
bought by AMD and two new generations were introduced.

## NANDs

It is possible to build any digital circuits entirely with NAND logic gates or
with just NOR gates (the case for the AGC, the Apollo Guidence Computer which
landed on the Moon). Before the Field Programmable Gate Arrays (FPGAs) many
projects used Gate Arrays. These were chips which had a large number of NAND
gates, the same for all clients, and the metal layer was specific for each
client.

Translating a design to NAND gates is a good way to get an idea of the
complexity of that design relative to others. 

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

The include in file *darkriscv.v* was commented out, as was the part after the
"ifndef \_\_YOSYS\_\_" since that doesn't work when called from Python.

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

The file was renamed to *cpu16.sv* since it needs System Verilog features and it
ALU module was renamed to xALU to not conflict with the Gowin built-in block.

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

Modules MUXCY and XORCY are names that conflict with a built-in blocks for Xilinx FPGAs,
so the ones in files *compat.v* and *cpu.v" were renamed to xMUXCY and xXORCY.

### ZPU Avalanche

The ZPU was designed to use the least FPGA possible while being fully compatible
with all the GNU programming tools, including GCC. The idea is that on an FPGA
even C is more of a scripting language as the heavy processing will be done by
hardware blocks.

Th Avalanche project translated the original VHDL implementation to System Verilog.
The System Verilog files were copied from [the original repository](https://github.com/sergev/zpu-avalanche.git)
in the top directory.

### Baby 8
