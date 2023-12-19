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

fpgas = {'ice40':{'synth':"synth_ice40"},
         'ecp5':{'synth':"synth_ecp5"},
         'gowin':{'synth':"synth_gowin"},
         'cyclonev':{'synth':"synth_intel_alm -family cyclonev"},
         'xilinx7':{'synth':"synth_xilinx"}
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

def collectFPGAs():
    for a,p in projects.items():
        if p['sel'].get():
            for b,f in fpgas.items():
                if f['sel'].get():
                    print(a,b)
    
frm = ttk.Frame(root, padding=10)
frm.grid()
r = 0
for n,f in fpgas.items():
    ttk.Checkbutton(frm, text=n, variable=f['sel'], onvalue=True, offvalue=False).grid(column=0, row=r)
    r += 1
r = 0
for n,p in projects.items():
    ttk.Checkbutton(frm, text=n, variable=p['sel'], onvalue=True, offvalue=False).grid(column=1, row=r)
    r += 1
ttk.Button(frm, text="Collect FPGA data", command=collectFPGAs).grid(column=1, row=numboxes)
ttk.Button(frm, text="Quit", command=root.destroy).grid(column=1, row=numboxes+1)
root.mainloop()
