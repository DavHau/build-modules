import os
import shutil


out_build = os.getenv("build")
shutil.copytree('/build', out_build)
