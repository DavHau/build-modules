import os

out = os.getenv('out')
print(out)
print("test", file=open(out, 'w'))
