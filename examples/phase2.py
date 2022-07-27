import os
import json

out = os.getenv('out')
outPrev = os.getenv('outPrev')

phase1_output = open(outPrev).read()
result = f"""
  {phase1_output}
  phase2 output
"""

print(result, file=open(out, 'w'))
