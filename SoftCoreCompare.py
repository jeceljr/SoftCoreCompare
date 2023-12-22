#!/usr/bin/python3

import os

from pyosys import libyosys as ys

from tkinter import *
from tkinter import ttk
root = Tk()

asics = True

try:
    from openlane.flows import Flow
except ImportError:
    asics = False

defaults = {'excludefpgas': [], 'excludeprojects': [], 'autogen': []}

import json
from pathlib import Path
d = Path('defaults.json')
if d.is_file():
    with d.open() as j:
        defaults = json.loads(j.read())

fpgas = {'ice40':{'synth':"synth_ice40",
                  'lut':['\\SB_LUT4'],
                  'reg':['\\SB_DFFSR','\\SB_DFFESR','\\SB_DFF','\\SB_DFFE','\\SB_DFFESS','\\SB_DFFSS'],
                  'dsp':[],
                  'dmem':[],
                  'bmem':['\\SB_RAM40_4K'],
                  'ignore':['$_TBUF_','\\SB_CARRY']},
         'ecp5':{'synth':"synth_ecp5",
                  'lut':['\\LUT4'],
                  'reg':['\\TRELLIS_FF'],
                  'dsp':['\\MULT18X18D'],
                  'dmem':['\\TRELLIS_DPR16X4'],
                  'bmem':['\\DP16KD','\\ECP5_PDPW16KD'],
                  'ignore':['$_TBUF_','\\CCU2C','\\PFUMX','\\L6MUX21']},
         'gowin':{'synth':"synth_gowin",
                  'lut':['\\LUT4','\\LUT3','\\LUT1','\\LUT2'],
                  'reg':['\\DFFR','\\DFFRE','\\DFFE','\\DFF','\\DFFSE','\\DFFS'],
                  'dsp':[],
                  'dmem':['\\RAM16SDP4','\\SPX9','\\SDPX9'],
                  'bmem':[],
                  'ignore':['\\VCC','\\ALU','\\GND','\\MUX2_LUT5','\\MUX2_LUT6','\\MUX2_LUT7','\\MUX2_LUT8','\\IBUF','\\OBUF','\\IOBUF','\\SP']},
         'cyclonev':{'synth':"synth_intel_alm -family cyclonev",
                  'lut':['\\MISTRAL_ALUT3','\\MISTRAL_ALUT4','\\MISTRAL_ALUT5','\\MISTRAL_ALUT2','\\MISTRAL_ALUT6'],
                  'reg':['\\MISTRAL_FF'],
                  'dsp':['\\MISTRAL_MUL18X18'],
                  'dmem':['\\MISTRAL_MLAB'],
                  'bmem':['\\MISTRAL_M10K','\\MISTRAL_M20K_SDP'],
                  'ignore':['$_TBUF_','\\MISTRAL_ALUT_ARITH','\\MISTRAL_OB','\\MISTRAL_IB','\\MISTRAL_IO','\\MISTRAL_NOT','\\MISTRAL_CLKBUF']},
         'xilinx7':{'synth':"synth_xilinx",
                  'lut':['\\LUT4','\\LUT3','\\LUT1','\\LUT2','\\LUT6','\\LUT5'],
                  'reg':['\\FDRE','\\FDSE'],
                  'dsp':['\\DSP48E1'],
                  'dmem':['\\RAM32M'],
                  'bmem':['\\RAMB18E1'],
                  'ignore':['\\IBUF','\\OBUF','\\IOBUF','\\MUXF7','\\INV','\\CARRY4','\\BUFG','\\MUXF8']}
         }

for n,f in fpgas.items():
    b = BooleanVar()
    b.set(n not in defaults['excludefpgas'])
    f['sel'] = b

projects = {}

d = Path('.')
for p in d.iterdir():
    if p.is_dir() and p.name != '.git':
        b = BooleanVar()
        b.set(p.name not in defaults['excludeprojects'])
        projects[p.name] = {'sel':b}

numboxes = max(len(fpgas),len(projects))

results = {}
unknown_cells = {}

def clearRes():
    results.clear()
    report.pack_forget()

def collectFPGA(proj,pconf,fname,f,res):
    design = ys.Design()
    res['lut'] = 0
    res['reg'] = 0
    res['dsp'] = 0
    res['dmem'] = 0
    res['bmem'] = 0
    for vf in pconf['VERILOG_FILES']:
      if vf[-3:] == ".sv":
          svopt = " -sv "
      else:
          svopt = ""
      ys.run_pass("read_verilog "+svopt+vf, design);
    ys.run_pass("hierarchy -top "+pconf['DESIGN_NAME'], design)
    ys.run_pass("flatten", design)
    ys.run_pass(f['synth'], design)
    for module in design.selected_whole_modules_warn():
      for cell in module.selected_cells():
          ct = cell.type.str()
          if ct in f['lut']:
              res['lut'] += 1
          elif ct in f['reg']:
              res['reg'] += 1
          elif ct in f['dsp']:
              res['dsp'] += 1
          elif ct in f['dmem']:
              res['dmem'] += 1
          elif ct in f['bmem']:
              res['bmem'] += 1
          elif ct not in f['ignore']:
              unknown_cells[ct] = fname

def collectFPGAs():
    for a,p in projects.items():
        if p['sel'].get():
            os.chdir(a)
            d = Path('config.json')
            if d.is_file():
               with d.open() as conf:
                   pconf = json.loads(conf.read())
               for b,f in fpgas.items():
                   if f['sel'].get():
                       if a not in results:
                           results[a] = {}
                       if b not in results[a]:
                           results[a][b] = {}
                       collectFPGA(a,pconf,b,f,results[a][b])
            os.chdir('..')
    print("Unknown Cells (please fix program if not empty):")
    print(unknown_cells)
    report.pack(side=TOP)

def collectNAND():
    for a,p in projects.items():
        if p['sel'].get():
            os.chdir(a)
            d = Path('config.json')
            if d.is_file():
                with d.open() as conf:
                    pconf = json.loads(conf.read())
                if a not in results:
                    results[a] = {}
                if 'NAND' not in results[a]:
                    results[a]['NAND'] = 0
                design = ys.Design()
                for vf in pconf['VERILOG_FILES']:
                    if vf[-3:] == ".sv":
                        svopt = " -sv "
                    else:
                        svopt = ""
                    ys.run_pass("read_verilog "+svopt+vf, design);
                ys.run_pass("hierarchy -top "+pconf['DESIGN_NAME'], design)
                ys.run_pass("flatten", design)
                ys.run_pass("check", design)
                ys.run_pass("clean", design)
                ys.run_pass("proc", design)
                ys.run_pass("fsm", design)
                ys.run_pass("opt", design)
                ys.run_pass("memory", design)
                ys.run_pass("opt", design)
                ys.run_pass("techmap", design)
                ys.run_pass("synth", design)
                ys.run_pass("dfflibmap -liberty ../cells.lib", design)
                ys.run_pass("abc -liberty ../cells.lib", design)
                ys.run_pass("techmap -map ../all2nand.v", design)
                ys.run_pass("freduce", design)
                ys.run_pass("opt_clean", design)
                ys.run_pass("check", design)
                for module in design.selected_whole_modules_warn():
                    for cell in module.selected_cells():
                        ct = cell.type.str()
                        if ct == '\\NAND':
                            results[a]['NAND'] += 1
                        else:
                            unknown_cells[a] = ct
            os.chdir('..')
    report.pack(side=TOP)

def collectASIC():
    print("to do")

def allAuto():
    print("generate all automatic reports from default.json")

def nextAuto():
    print("generate the next report defined in default.json")

def newReport():
    print("Results:")
    print(results)

frm = ttk.Frame(root, padding=10)
frm.pack()
select = ttk.Frame(frm)
select.pack(side=TOP)
c1 = ttk.Frame(select)
c1.pack(side=LEFT,fill=Y,expand=1)
ttk.Label(c1, text="   Selected FPGAs   ").pack(side=TOP)
for n,f in fpgas.items():
    ttk.Checkbutton(c1, text=n, variable=f['sel'], onvalue=True, offvalue=False,command=clearRes).pack(side=TOP,fill=X,expand=1)
c2 = ttk.Frame(select)
c2.pack(side=LEFT)
ttk.Label(c2, text="   Selected Soft Cores   ").pack(side=TOP)
for n,p in projects.items():
    ttk.Checkbutton(c2, text=n, variable=p['sel'], onvalue=True, offvalue=False,command=clearRes).pack(side=TOP,fill=X,expand=1)
collect = ttk.Frame(frm)
collect.pack(side=TOP)
ttk.Button(collect, text="Collect FPGA data", command=collectFPGAs).pack(side=LEFT)
ttk.Button(collect, text="Collect NAND data", command=collectNAND).pack(side=LEFT)
if asics:
    ttk.Button(collect, text="Collect ASIC data", command=collectASIC).pack(side=LEFT)
ttk.Button(frm, text="Quit", command=root.destroy).pack(side=TOP)
report = ttk.Frame(frm)
report.pack(side=TOP)
ttk.Button(report, text="All Auto", command=allAuto).pack(side=LEFT)
ttk.Button(report, text="Next Auto", command=nextAuto).pack(side=LEFT)
ttk.Button(report, text="New Report", command=newReport).pack(side=LEFT)
clearRes()
root.mainloop()
