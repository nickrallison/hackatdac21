#!/bin/bash

# RUN:
# source scripts/cores_download/hackatdac21/download.bash

# DEPENDENCIES
# pyenv
# pyenv-virtualenv
# 

# INSTALL
# pyenv install 2.7.18
# pyenv install 3.13.7

export ORIGINAL_DIR=$(pwd)
# export PITON_ROOT="$(pwd)/generated/hackatdac21"
export PITON_ROOT="$(pwd)"


if [ ! -d "$PITON_ROOT/generated" ]; then
    mkdir -p $PITON_ROOT/generated
    cd $PITON_ROOT
    git checkout bcae7aba7f9daee8ad2cfd47b997ac7ad6611034
    cd $ORIGINAL_DIR
    cp $ORIGINAL_DIR/scripts/exu_bw_r_irf_common.core_ $PITON_ROOT/piton/design/chip/tile/sparc/exu/bw_r_irf/common/rtl/exu_bw_r_irf_common.core
    cp $ORIGINAL_DIR/scripts/preproc.py                $PITON_ROOT/piton/tools/src/fusesoc/preproc.py
    cp $ORIGINAL_DIR/scripts/preprocessor.core_        $PITON_ROOT/piton/tools/src/fusesoc/preprocessor.core
fi

if [ ! -d ./venv ]; then
  $HOME/.pyenv/versions/3.13.7/bin/python -m venv ./venv
fi

source venv/bin/activate
source $PITON_ROOT/piton/piton_settings.bash
source $PITON_ROOT/piton/ariane_setup.sh

venv/bin/pip install fusesoc
venv/bin/pip install pyyaml

rm -f fusesoc.conf
fusesoc library add openpiton $PITON_ROOT

chmod +x $PITON_ROOT/piton/tools/bin/pyhp.py

source venv/bin/activate

export PATH="$PATH:$PITON_ROOT/piton/tools/bin"
export PATH="$HOME/.pyenv/versions/2.7.18/bin:$PATH"

### TILE ###
fusesoc run --target=pickle tile
mv build/openpiton__tile_0.1/pickle-icarus/openpiton__tile_0.1 generated/openpiton_tile.v
yosys -p "verific -sv generated/openpiton_tile.v" -p "hierarchy -top tile" -p proc -p memory -p opt_clean -p "write_json generated/openpiton_tile.json"

gzip generated/openpiton_tile.json