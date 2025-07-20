#!/bin/bash

# make some directories for my custom code

mkdir /Users/andy/qmk_firmware/keyboards/preonic/keymaps/teknostatik
mkdir /Users/andy/qmk_firmware/keyboards/planck/keymaps/teknostatik
mkdir /Users/andy/qmk_firmware/keyboards/crkbd/keymaps/teknostatik
mkdir /Users/andy/qmk_firmware/keyboards/crkbd/keymaps/teknostatik36
mkdir /Users/andy/qmk_firmware/keyboards/hs60/v2/hhkb/keymaps/teknostatik/
mkdir /Users/andy/qmk_firmware/keyboards/40percentclub/gherkin/keymaps/teknostatik
mkdir /Users/andy/qmk_firmware/keyboards/fr4/unix60/keymaps/teknostatik
mkdir /Users/andy/qmk_firmware/keyboards/ferris/keymaps/teknostatik_mb
mkdir /Users/andy/qmk_firmware/keyboards/ferris/keymaps/teknostatik
mkdir /Users/andy/qmk_firmware/keyboards/cantor/keymaps/teknostatik
mkdir /Users/andy/qmk_firmware/keyboards/nullbitsco/tidbit/keymaps/teknostatik
mkdir /Users/andy/qmk_firmware/keyboards/ok60/keymaps/teknostatik
mkdir /Users/andy/qmk_firmware/keyboards/planck/rev7/keymaps/teknostatik7

# add files to the directories

rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/planck/ /Users/andy/qmk_firmware/keyboards/planck/keymaps/teknostatik/
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/preonic/ /Users/andy/qmk_firmware/keyboards/preonic/keymaps/teknostatik/
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/corne/ /Users/andy/qmk_firmware/keyboards/crkbd/keymaps/teknostatik/
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/corne36/ /Users/andy/qmk_firmware/keyboards/crkbd/keymaps/teknostatik36/
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/HHKB/ /Users/andy/qmk_firmware/keyboards/hs60/v2/hhkb/keymaps/teknostatik/
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/gherkin/ /Users/andy/qmk_firmware/keyboards/40percentclub/gherkin/keymaps/teknostatik/
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/unix60/ /Users/andy/qmk_firmware/keyboards/fr4/unix60/keymaps/teknostatik/
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/ferris_sweep_mechboards/ /Users/andy/qmk_firmware/keyboards/ferris/keymaps/teknostatik_mb/
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/ferris_sweep/ /Users/andy/qmk_firmware/keyboards/ferris/keymaps/teknostatik/
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/cantor/ /Users/andy/qmk_firmware/keyboards/cantor/keymaps/teknostatik/
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/tidbit/ /Users/andy/qmk_firmware/keyboards/nullbitsco/tidbit/keymaps/teknostatik
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/ok60/ /Users/andy/qmk_firmware/keyboards/ok60/keymaps/teknostatik/
rsync -avz /Users/andy/Dropbox/Scripts/github/keyboards/planck_rev7/ /Users/andy/qmk_firmware/keyboards/planck/rev7/keymaps/teknostatik7

# run test builds of all firmware

qmk compile -kb preonic/rev3 -km teknostatik
qmk compile -kb plank/rev6_drop -km teknostatik
qmk compile -kb crkbd/rev1 -km teknostatik
qmk compile -kb crkbd/rev1 -km teknostatik36
qmk compile -kb hs60/v2/hhkb -km teknostatik
qmk compile -kb 40percentclub/gherkin -km teknostatik
qmk compile -kb fr4/unix60 -km teknostatik
qmk compile -c -kb crkbd/rev1 -km teknostatik -e CONVERT_TO=elite_pi
qmk compile -kb ferris/sweep -km teknostatik
qmk compile -kb ferris/sweep -km teknostatik_mb
qmk compile -c -kb crkbd/rev1 -km teknostatik -e CONVERT_TO=promicro_rp2040
qmk compile -c -kb ferris/sweep -km teknostatik_mb -e CONVERT_TO=promicro_rp2040
qmk compile -kb nullbitsco/tidbit -km teknostatik
qmk compile -kb ok60 -km teknostatik
qmk compile -kb planck/rev7 -km teknostatik7
qmk compile -kb cantor -km teknostatik

# update firmware in repository

cp /Users/andy/qmk_firmware/*.hex /Users/andy/Dropbox/Scripts/github/keyboards/Firmware/
cp /Users/andy/qmk_firmware/*.bin /Users/andy/Dropbox/Scripts/github/keyboards/Firmware/
cp /Users/andy/qmk_firmware/*.uf2 /Users/andy/Dropbox/Scripts/github/keyboards/Firmware/

