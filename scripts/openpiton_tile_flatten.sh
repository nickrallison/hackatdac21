#!/bin/sh

# yosys -p "verific -sv build/openpiton__chip_0.1/pickle-icarus/openpiton__chip_0.1.v" -p "hierarchy -top chip" -p proc -p memory -p opt_clean -p flatten -p "write_json generated/openpiton_chip_full.json"
# yosys -p "verific -sv generated/openpiton_tile.v" -p "hierarchy -top tile" -p proc -p memory -p opt_clean -p flatten -p "write_json generated/openpiton_tile_full.json"
# yosys -p "verific -sv generated/openpiton_tile.v" -p "hierarchy -top tile" -p proc -p memory -p opt_clean -p flatten -p "write_json generated/openpiton_tile_full.json"
cp generated/openpiton_tile.json.gz generated/openpiton_tile_bak.json.gz
rm generated/openpiton_tile.json
gzip -d generated/openpiton_tile.json.gz
mv generated/openpiton_tile_bak.json.gz generated/openpiton_tile.json.gz

sed -E 's/dcd_fuse_repair_en//g' generated/openpiton_tile.json
sed -E '/[[:space:]]*"fuse_dcd_repair_en": \[ "0", "0" \],/d' generated/openpiton_tile.json

yosys -p "read_json generated/openpiton_tile.json" -p "hierarchy -top tile" -p proc -p memory -p opt_clean -p "flatten" -p "write_json generated/openpiton_tile_flat.json"