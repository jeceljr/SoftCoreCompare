# SoftCoreCompare

This project generated the data used in the article ["Design and Evaluation of Open-Source Soft-Core Processors"](https://www.mdpi.com/2079-9292/13/4/781).

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
using the Nix package tool has been tested in this project and it worked well
when invoked directly, but as explained below it wasn't able to bee called from
the Python program. The optional
[Volare](https://github.com/efabless/volare) PDK management system was used to
select the right version of the Skywater 130nm PDK to generate the hardware for
the cores.

If the program can't find OpenLane then it won't show the 'Collect ASIC Data"
button. Despite having a working installation via Nix I had to install it
again via "python3 -m pip install --upgrade openlane" for the application to
find it. To make this work also required compiling 
[Verilator](https://github.com/verilator/verilator) from the sources
since the version in the Debian repository (4.x) was not new enough. 
[OpenSTA](https://github.com/The-OpenROAD-Project/OpenSTA)
was also built from the sources. 
[OpenRoad](https://github.com/The-OpenROAD-Project/OpenROAD.git) itself is
also needed. It seems to contain OpenSTA so that is probably not needed
separately.
