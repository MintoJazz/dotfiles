#!/bin/bash

script_dir=$(dirname "$(readlink -f "$0")")
cd $script_dir

includes="./include/"
i3_config="./config"

rm -f "$i3_config"
cat "${includes}"*.conf | grep -vE '^(\s*#|$)' > "$i3_config"
