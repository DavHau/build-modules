import json
import os
import sys

builder = os.getenv('builder')
args = os.getenv('args')
if not args:
  args = ""


phasesFile = os.getenv('phases')
with open(phasesFile) as f:
  phases = json.load(f)

print(f"start iterating phases", file=sys.stderr)
for phase_name, script in phases.items():
  print(f"running phase: {phase_name}", file=sys.stderr)
  print(f"will execute: {builder} {args} {script}", file=sys.stderr)
  returncode = os.system(f"{builder} {args} {script}")
  if returncode:
    exit(returncode)
