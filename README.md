Github action :

Main : [![build](https://github.com/orix-software/cardridge/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/orix-software/cardridge/actions/workflows/main.yml)

Develop : [![build](https://github.com/orix-software/cardridge/actions/workflows/main.yml/badge.svg?branch=develop)](https://github.com/orix-software/cardridge/actions/workflows/main.yml)

Build cardridge (.r64 files) for twilighte board and push it in repo.orix.oric.org

It generates a .r64 file which contains last shell rom (16KB), with last basic11 (16KB) and last kernel (16KB). The last 16KB is an empty rom. In that case we have a 64KB file

# Build

make

# Install in oricutron

* Put kernel.rom in bank 7
* Put basic_noram.rom in bank 6
* Put shell.rom in bank 5
* Put monitor.rom in bank 4
* Put empty-rom.rom in bank 3,2,1
