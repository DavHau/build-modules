import json
import os
import sys


environ = os.environ.copy()

phasesFile = os.getenv('phases')
with open(phasesFile) as f:
  phases = json.load(f)

print(f"start iterating phases", file=sys.stderr)
for phase_name, phase in phases.items():
  script = phase['script']
  interpreter = phase['interpreter']
  args = ' '.join(interpreter['args'])
  builder = interpreter['builder']

  os.environ = environ.copy()
  os.environ.update(interpreter['env'])

  print(f"running phase: {phase_name}", file=sys.stderr)
  print(f"will execute: {builder} {args} {script}", file=sys.stderr)
  returncode = os.system(f"{builder} {args} {script}")
  if returncode:
    exit(returncode)
