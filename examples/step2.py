import os
import json

out = os.getenv('out')
outPrev = os.getenv('outPrev')

step1_output = open(outPrev).read()
result = f"""
  {step1_output}
  step2 output
"""

print(result, file=open(out, 'w'))
