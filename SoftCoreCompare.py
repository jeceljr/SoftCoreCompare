#!/usr/bin/python3

from tkinter import *
from tkinter import ttk
root = Tk()

defaults = {'excludefpgas': [], 'excludeprojects': [], 'autogen': []}

import json
from pathlib import Path
d = Path('defaults.json')
if d.is_file():
    with d.open() as j:
        defaults = json.loads(j.read())

fpgas = {'ice40':{'synth':"synth_ice40",
                  'lut':[],
                  'reg':[],
                  'dsp':[],
                  'dmem':[],
                  'bmem':[]},
         'ecp5':{'synth':"synth_ecp5",
                  'lut':[],
                  'reg':[],
                  'dsp':[],
                  'dmem':[],
                  'bmem':[]},
         'gowin':{'synth':"synth_gowin",
                  'lut':[],
                  'reg':[],
                  'dsp':[],
                  'dmem':[],
                  'bmem':[]},
         'cyclonev':{'synth':"synth_intel_alm -family cyclonev",
                  'lut':[],
                  'reg':[],
                  'dsp':[],
                  'dmem':[],
                  'bmem':[]},
         'xilinx7':{'synth':"synth_xilinx",
                  'lut':[],
                  'reg':[],
                  'dsp':[],
                  'dmem':[],
                  'bmem':[]}
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

def clearRes():
    results.clear()

def collectFPGA(proj,f,res):
    print(proj,f)
    res['lut'] = 0
    res['reg'] = 0


def collectFPGAs():
    for a,p in projects.items():
        if p['sel'].get():
            for b,f in fpgas.items():
                if f['sel'].get():
                    if a not in results:
                        results[a] = {}
                    if b not in results[a]:
                        results[a][b] = {}
                    collectFPGA(a,b,results[a][b])
    print(results)

def collectNAND():
    print("unimplemented")

def collectASIC():
    print("to do")

frm = ttk.Frame(root, padding=10)
frm.grid()
r = 0
for n,f in fpgas.items():
    ttk.Checkbutton(frm, text=n, variable=f['sel'], onvalue=True, offvalue=False,command=clearRes).grid(column=0, row=r)
    r += 1
r = 0
for n,p in projects.items():
    ttk.Checkbutton(frm, text=n, variable=p['sel'], onvalue=True, offvalue=False,command=clearRes).grid(column=1, row=r)
    r += 1
ttk.Button(frm, text="Collect FPGA data", command=collectFPGAs).grid(column=1, row=numboxes)
ttk.Button(frm, text="Collect NAND data", command=collectNAND).grid(column=1, row=numboxes+1)
ttk.Button(frm, text="Collect ASIC data", command=collectASIC).grid(column=1, row=numboxes+2)
ttk.Button(frm, text="Quit", command=root.destroy).grid(column=1, row=numboxes+3)
root.mainloop()
