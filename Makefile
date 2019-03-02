AS=xa
CC=cl65
CFLAGS=-ttelestrat
LDFILES=
ASCA65=ca65
ORIX_ROM=roms

all : init build twilightecard telestratcardridge
.PHONY : all

#HOMEDIR=/home/travis/bin/
#HOMEDIR_ORIX=/home/travis/build/oric-software/orix
#ORIX_VERSION=1

#SOURCE_BANK7=src/kernel.asm
#SOURCE_BANK5=src/orixbank5.asm
#SOURCE_BANK4=src/monitor_bank4.asm
#SOURCE_BANK1=src/empty.asm

#TELESTRAT_TARGET_RELEASE=release/telestrat

#ORIX_ROM=orix

#ATMOS_ROM=ROMCH376_noram.rom

#MYDATE = $(shell date +"%Y-%m-%d %H:%m")

#ASFLAGS= -W -e error.txt -l xa_labels.txt -D__DATEBUILT__="$(MYDATE)"

TELESTRAT_FOLDER=telestrat

HOMEDIRBIN=compiledir/

INITIAL_FOLDER=`pwd`

LIST="empty-rom shell basic orix monitor forth"

init:
	for I in ${LIST}; do echo rm $I; done
	rm -rf empty-rom
	rm -rf kernel
	rm -rf shell
	rm -rf basic
	rm -rf orix
	rm -rf monitor
	rm -rf forth
	rm -rf md2hlp
	rm -rf buildTestAndRelease
	rm -rf ${HOMEDIRBIN}
	mkdir -p roms/oricutron/6502/
	mkdir -p roms/oricutron/65c02/
	mkdir -p roms/telestrat/6502/
	mkdir -p roms/telestrat/65c02/
	mkdir -p roms/twilighte_card_v05/6502/		
	mkdir -p roms/twilighte_card_v05/65c02/	
  
build:
	git clone	https://github.com/oric-software/buildTestAndRelease.git
	git clone   https://github.com/assinie/md2hlp.git
	git clone	https://github.com/orix-software/shell.git
	git clone	https://github.com/orix-software/basic.git
	git clone	https://github.com/orix-software/empty-rom.git
	git clone	https://github.com/oric-software/orix.git
	git clone	https://github.com/orix-software/monitor.git
	git clone	https://github.com/orix-software/forth.git
	git clone	https://github.com/orix-software/kernel.git
	mkdir buildTestAndRelease/${HOMEDIRBIN}
	cd buildTestAndRelease && ./make.sh ${INITIAL_FOLDER}/${HOMEDIRBIN}
	cd shell && make
	cd empty-rom/ && make
	cd orix/ && make
	cd monitor && make
	cd forth && make configure && make && make
telestratcardridge:	
	echo Generating for telestrat
	cat empty-rom/empty-rom.rom > roms/telestrat/6502/cardridge_first_slot_3_banks.rom
	cat shell/shell.rom >> roms/telestrat/6502/cardridge_first_slot_3_banks.rom
	cat basic/bin/basic_noram.rom  >> roms/telestrat/6502/cardridge_first_slot_3_banks.rom
	cat orix/build/usr/share/orix-1/6502/kernel.rom >> roms/telestrat/6502/cardridge_first_slot_3_banks.rom

twilightecard:
	echo Generating for Twilighte card 7 banks
	cat empty-rom/empty-rom.rom > roms/twilighte_card_v05/6502/orix.rom
	cat empty-rom/empty-rom.rom >> roms/twilighte_card_v05/6502/orix.rom
	cat forth/build/cart/TeleForth.rom >> roms/twilighte_card_v05/6502/orix.rom
	cat monitor/monitor.rom >> roms/twilighte_card_v05/6502/orix.rom
	cat shell/shell.rom >> roms/twilighte_card_v05/6502/orix.rom
	cat basic/bin/basic_noram.rom  >> roms/twilighte_card_v05/6502/orix.rom
	cat orix/build/usr/share/orix-1/6502/kernel.rom >> roms/twilighte_card_v05/6502/orix.rom
	echo Generating for Twilighte card 32 banks ROM
	cat empty-rom/empty-rom.rom > roms/twilighte_card_v05/6502/orixa.rom
	cat empty-rom/empty-rom.rom >> roms/twilighte_card_v05/6502/orixa.rom
	cat forth/build/cart/TeleForth.rom >> roms/twilighte_card_v05/6502/orixa.rom
	cat monitor/monitor.rom >> roms/twilighte_card_v05/6502/orixa.rom
	cat shell/shell.rom >> roms/twilighte_card_v05/6502/orixa.rom
	cat basic/bin/basic_noram.rom  >> roms/twilighte_card_v05/6502/orixa.rom
	cat orix/build/usr/share/orix-1/6502/kernela.rom >> roms/twilighte_card_v05/6502/orixa.rom

	echo Generating for Oricutron
	cp empty-rom/empty-rom.rom roms/oricutron/6502/
	cp monitor/monitor.rom roms/oricutron/6502/
	cp shell/shell.rom roms/oricutron/6502/
	cp basic/bin/basic_noram.rom roms/oricutron/6502/
	cp orix/build/usr/share/orix-1/6502/kernel.rom roms/oricutron/6502/

test:
	cp README.md roms/
	cd roms && tar -c * > ../roms.tar &&	cd ..
	filepack roms.tar roms.pkg
	gzip roms.tar
	mv roms.tar.gz $(ORIX_ROM).tgz
	php buildTestAndRelease/publish/publish2repo.php $(ORIX_ROM).pkg ${hash} 6502 pkg alpha
	php buildTestAndRelease/publish/publish2repo.php $(ORIX_ROM).tgz ${hash} 6502 tgz alpha

