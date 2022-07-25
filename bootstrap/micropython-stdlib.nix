{
  runCommand,
  micropython-lib-src,
}:
runCommand "micropython-stdlib" {} ''
  mkdir -p $out/lib
  for collection in unix-ffi python-stdlib; do
    for package in $(ls ${micropython-lib-src}/$collection ); do
      path=${micropython-lib-src}/$collection/$package
      
      # skip duplicated os module
      if [[ $path == *python-stdlib/os ]]; then
        continue
      fi

      if [ -d $path ]; then
        echo "installing $path"
        if [ -e $path/$package.py ]; then
          cp $path/$package.py $out/lib/
        elif [ -d $path/$package ]; then
          cp -r $path/$package $out/lib/
        else
          for node in $(ls $path); do
            if [ -d $out/lib/$node ]; then
              chmod +w $out/lib/$node/
              cp -r $path/$node/* $out/lib/$node/
            else
              cp -r $path/$node $out/lib/
            fi
          done
          rm -rf $out/lib/{setup.py,metadata.txt}
          rm -rf $out/lib/@*
          rm -rf $out/lib/test_*
          rm -rf $out/lib/example_*
        fi
      fi
    done
  done
''
