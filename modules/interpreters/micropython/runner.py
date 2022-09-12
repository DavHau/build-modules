import json
import os
import sys

builder = os.getenv('builder')
args = os.getenv('args')


phasesFile = os.getenv('phases')
with open(phasesFile) as f:
  phasesList = json.load(f)

print(f"start iterating phases", file=sys.stderr)
def run_phases():
  for phase in phasesList:
    phase_name = phase['name']
    print(f"running phase: {phase_name}", file=sys.stderr)
    os.system(f"{builder} {args} {phase['script']}")

