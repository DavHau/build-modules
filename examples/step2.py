import os
import json

out = os.getenv('out')
outPrev = os.getenv('outPrev')
print(f"outPrev: {outPrev}")
print(f"outPrev content: {open(outPrev).read()}")

info = dict(
  foo="bar",
  abc="123",
)
with open(out, 'w') as fOut:
  json.dump(info, fOut)
