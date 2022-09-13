import os
import shutil
import stat
import sys


def copy(src, dst, *, follow_symlinks=True):
    """Copy data and mode bits ("cp src dst"). Return the file's destination.
    The destination may be a directory.
    Clears the readonly bit while copying the file.
    If follow_symlinks is false, symlinks won't be followed. This
    resembles GNU's "cp -P src dst".
    If source and destination are the same file, a SameFileError will be
    raised.
    """
    if os.path.isdir(dst):
        dst = os.path.join(dst, os.path.basename(src))
    shutil.copyfile(src, dst, follow_symlinks=follow_symlinks)
    shutil.copymode(src, dst, follow_symlinks=follow_symlinks)
    os.chmod(dst, stat.S_IWUSR)

    return dst


build_dir_prev = os.getenv("buildDirPrev")
out_prev = os.getenv("outPrev")
out = os.getenv("out")

if out_prev:
  print("copying output from previous derivation", file=sys.stderr)
  if os.path.isfile(out_prev):
    copy(out_prev, out)
  else:
    shutil.copytree(out_prev, out, copy_function=copy, dirs_exist_ok=True)

if build_dir_prev:
  print("copying build state from previous derivation", file=sys.stderr)
  shutil.copytree(build_dir_prev, '/build', copy_function=copy, dirs_exist_ok=True)

