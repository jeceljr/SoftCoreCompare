#!/usr/bin/python3

defaults = {'excludefpgas': [], 'excludeprojects': [], 'autogen': []}

import json
from pathlib import Path
d = Path('defaults.json')
if d.is_file():
    with d.open() as j:
        defaults = json.loads(j.read())
print(defaults)

fpgas = {'ice40':{'sel':True},
         'ecp5':{'sel':True},
         'gowin':{'sel':True},
         'cyclonev':{'sel':True},
         'xilinx7':{'sel':True}
         }

projects = {}

d = Path('.')
for p in d.iterdir():
    if p.is_dir():
        projects[p.name] = {'sel':True}

print(projects)

from tkinter import *
from tkinter import ttk
root = Tk()
frm = ttk.Frame(root, padding=10)
frm.grid()
ttk.Label(frm, text="Hello World!").grid(column=0, row=0)
ttk.Button(frm, text="Quit", command=root.destroy).grid(column=1, row=0)
root.mainloop()
