import os

out = os.getenv('out')
print("step1 output", file=open(out, 'w'))
