AS=xa
CC=cl65
CFLAGS=-ttelestrat
LDFILES=
ORIX_ROM=roms
BRANCH=master

ifeq ($(CC65_HOME),)
        CC = cl65
        AS = ca65
        LD = ld65
        AR = ar65
else
        CC = $(CC65_HOME)/bin/cl65
        AS = $(CC65_HOME)/bin/ca65
        LD = $(CC65_HOME)/bin/ld65
        AR = $(CC65_HOME)/bin/ar65
endif

all : init buildme twilightecard  twilightecardorixcfgkernel twilightecardorixcfgforthetc telestratcardridge   twilightecardorixemptyrom
.PHONY : all

empty_rom_git=https://github.com/orix-software/empty-rom.git
monitor_git=https://github.com/orix-software/monitor.git
forth_git=https://github.com/orix-software/forth.git
basic_git=https://github.com/orix-software/basic.git
md2hlp_git=https://github.com/assinie/md2hlp.git

TELESTRAT_FOLDER=telestrat

HOMEDIRBIN=compiledir/

INITIAL_FOLDER=`pwd`

ifdef TRAVIS_BRANCH
ifneq ($(TRAVIS_BRANCH), master)
RELEASE=alpha
VERSION=alpha
else
RELEASE:=$(shell cat VERSION)
VERSION:=$(shell cat VERSION)
endif
endif

PATH_BASIC11_USB=usr/share/basic11/basicus2.rom
PATH_BASIC11_SD=usr/share/basic11/basicsd2.rom
PATH_FORTH_ROM=usr/share/forth/2021.2/forth.rom
PATH_SYSTEMD_ROM=usr/share/systemd/systemd.rom
PATH_EMPTY_ROM=usr/share/emptyrom/emptyrom.rom
               

LIST="empty-rom shell basic orix monitor forth"
clean:
	rm -rf src/*
init:
	@mkdir -p src/
	@export MAKE=make
	@echo Update kernel
	@curl http://repo.orix.oric.org/dists/official/tgz/6502/kernel.tgz --output kernel.tgz
	@echo Update shell
	@curl http://repo.orix.oric.org/dists/official/tgz/6502/shell.tgz --output shell.tgz
	@gzip -dc shell.tgz | tar -xvf -
	@echo Update emptyrom
	@curl http://repo.orix.oric.org/dists/official/tgz/6502/emptyrom.tgz --output emptyrom.tgz
	@gzip -dc emptyrom.tgz | tar xvf -
	@echo Update monitor
	@curl http://repo.orix.oric.org/dists/official/tgz/6502/monitor.tgz --output monitor.tgz
	@echo Update forth
	@curl http://repo.orix.oric.org/dists/official/tgz/6502/forth.tgz --output forth.tgz
	@echo Update systemd
	@curl http://repo.orix.oric.org/dists/official/tgz/6502/systemd.tgz --output systemd.tgz
	@echo Update basic
	@curl http://repo.orix.oric.org/dists/official/tgz/6502/basic.tgz --output basic.tgz
	@echo Update md2hlp
	@if [ -d "src/md2hlp" ]; then  cd src/md2hlp  && git pull && git submodule  init && git submodule update --recursive --remote && cd ../../; else cd  src/ && git clone $(md2hlp_git)  && cd ..;fi 				
	@mkdir src/forth/md2hlp/src -p
	@cp src/md2hlp/src/* src/forth/md2hlp/src
	@cp src/md2hlp/src/md2hlp.py3 src/forth/md2hlp/src/md2hlp.py
	@cd src/forth/md2hlp/src/ 
	#&& dos2unix *	
	mkdir -p roms/oricutron/6502/
	mkdir -p roms/oricutron/65c02/
	mkdir -p roms/telestrat/6502/
	mkdir -p roms/telestrat/65c02/
	mkdir -p roms/twilighte_card_v05/6502/		
	mkdir -p roms/twilighte_card_v05/65c02/	
	mkdir -p build/usr/share/carts/
  
buildme:

	@echo "##########################"
	@echo "#    Building Kernel     #"
	@echo "##########################"
	@gzip -dc kernel.tgz | tar -xvf -	
	@echo "##########################"
	@echo "#    Building Monitor    #"
	@echo "##########################"	
	@gzip -dc monitor.tgz | tar -xvf -		
	@echo "##########################"
	@echo "#    Building Basic      #"
	@echo "##########################"	
	@gzip -dc basic.tgz | tar -xvf -
	@echo "##########################"
	@echo "#    Building Forth      #"
	@echo "##########################"
	@gzip -dc forth.tgz | tar -xvf -
	@echo "##########################"
	@echo "#    Building Systemd    #"
	@echo "##########################"
	@gzip -dc systemd.tgz | tar -xvf -


telestratcardridge:	
	@echo "###################################"
	@echo "#    Build Telestrat cardridge    #"
	@echo "###################################"	

	echo Generating for telestrat First cardridge
	cat $(PATH_EMPTY_ROM) > roms/telestrat/6502/cardridge_first_slot_3_banks.rom
	cat src/shell/shellsd.rom >> roms/telestrat/6502/cardridge_first_slot_3_banks.rom
	cat $(PATH_BASIC11_SD)   >> roms/telestrat/6502/cardridge_first_slot_3_banks.rom
	cat src/kernel/kernelsd.rom >> roms/telestrat/6502/cardridge_first_slot_3_banks.rom
	echo Generating for telestrat Second cardridge
	cat $(PATH_FORTH_ROM) > roms/telestrat/6502/cardridge_second_slot_4_banks.rom
	cat src/monitor/monitor.rom >> roms/telestrat/6502/cardridge_second_slot_4_banks.rom
	cat $(PATH_EMPTY_ROM) >> roms/telestrat/6502/cardridge_second_slot_4_banks.rom
	cat $(PATH_EMPTY_ROM) >> roms/telestrat/6502/cardridge_second_slot_4_banks.rom

twilightecard:
	@echo "###################################"
	@echo "#    Build Twilighte board ROM    #"
	@echo "###################################"	
	echo Generating for Twilighte card 7 banks root sd
	ls -l usr/share/emptyrom/
#	ls -l
	cat $(PATH_EMPTY_ROM) > roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat usr/share/forth/2021.2/forth.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/monitor/monitor.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/shell/shellsd.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_BASIC11_SD)  >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/kernel/kernelsd.rom >> roms/twilighte_card_v05/6502/orixsd.rom	
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom	
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixsd.rom
	@echo "##############################################"
	@echo "#    Build Twilighte board ROM  USB DEFAULT  #"
	@echo "##############################################"	
	echo Generating for Twilighte card 7 banks root usb
	cat $(PATH_EMPTY_ROM) > roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat usr/share/forth/2021.2/forth.rom >> roms/twilighte_card_v05/6502/orixusb.rom
	cat src/monitor/monitor.rom >> roms/twilighte_card_v05/6502/orixusb.rom
	cat src/shell/shell.rom >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_BASIC11_USB)  >> roms/twilighte_card_v05/6502/orixusb.rom
	cat src/kernel/kernelus.rom >> roms/twilighte_card_v05/6502/orixusb.rom	
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom	
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/orixusb.rom


twilightecardorixcfgkernel:
	@echo "###################################################"
	@echo "#    Build .r64 orixcfg (kernel, basic11 & shell )#"
	@echo "###################################################"	

	#@cat src/kernel/src/headerorixcfg.bin > kernelsd.roh
	@cat src/shell/shellsd.rom > roms/twilighte_card_v05/6502/kernelsd.r64
	@cat $(PATH_BASIC11_SD) >> roms/twilighte_card_v05/6502/kernelsd.r64
	@cat src/kernel/kernelsd.rom >> roms/twilighte_card_v05/6502/kernelsd.r64
	@cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/kernelsd.r64
	@cat roms/twilighte_card_v05/6502/kernelsd.r64 >> kernelsd.roh


	cat src/shell/shell.rom > roms/twilighte_card_v05/6502/kernelus.r64
	cat $(PATH_BASIC11_USB) >> roms/twilighte_card_v05/6502/kernelus.r64
	cat src/kernel/kernelus.rom >> roms/twilighte_card_v05/6502/kernelus.r64
	cat $(PATH_EMPTY_ROM) >> roms/twilighte_card_v05/6502/kernelus.r64
	#@cat src/kernel/src>headerorixcfg.bin > kernelus.roh
	@cat roms/twilighte_card_v05/6502/kernelus.r64 >> kernelus.roh
	

	mkdir build/usr/share/carts/$(VERSION)/ -p
	mkdir -p build/etc/orixcfg/
	echo "Kernelsd, basic11sd, shellsd;/usr/share/carts/$(VERSION)/kernelsd.r64" > build/etc/orixcfg/carts.cnf
	echo "Kernelus, basic11us, shellus;/usr/share/carts/$(VERSION)/kernelus.r64" > build/etc/orixcfg/carts.cnf
	cp roms/twilighte_card_v05/6502/kernelsd.r64 build/usr/share/carts/$(VERSION)/
	cp roms/twilighte_card_v05/6502/kernelus.r64 build/usr/share/carts/$(VERSION)/
#	cp kernelus.roh build/usr/share/carts/$(VERSION)
	#cp kernelsd.roh build/usr/share/carts/$(VERSION)

twilightecardorixcfgforthetc:
	@echo "###################################################"
	@echo "#    Build .r64 orixcfg forth                     #"
	@echo "###################################################"	

	cat $(PATH_EMPTY_ROM) > roms/twilighte_card_v05/6502/bank4321.r64
	cat usr/share/forth/2021.2/forth.rom >> roms/twilighte_card_v05/6502/bank4321.r64
	cat src/monitor/monitor.rom >> roms/twilighte_card_v05/6502/bank4321.r64
	cat $(PATH_EMPTY_ROM) > roms/twilighte_card_v05/6502/bank4321.r64
	#cat $(PATH_SYSTEMD_ROM) >> roms/twilighte_card_v05/6502/bank4321.r64	
	cp roms/twilighte_card_v05/6502/bank4321.r64  roms/twilighte_card_v05/6502/fullus.bk8
	cp roms/twilighte_card_v05/6502/bank4321.r64  roms/twilighte_card_v05/6502/fullsd.bk8
	cat roms/twilighte_card_v05/6502/kernelus.r64 >> roms/twilighte_card_v05/6502/fullus.bk8
	cat roms/twilighte_card_v05/6502/kernelsd.r64 >> roms/twilighte_card_v05/6502/fullsd.bk8
	mkdir build/usr/share/carts/$(VERSION)/ -p

	mkdir -p build/etc/orixcfg/
	cp roms/twilighte_card_v05/6502/bank4321.r64 build/usr/share/carts/$(VERSION)/mfee.r64
	echo "Monitor 2020.1-Forth 2020.2;/usr/share/carts/2020.2/mfee.r64" >> build/etc/orixcfg/carts.cnf

twilightecardorixemptyrom:
	@echo "###################################################"
	@echo "#    Build .r64 empty rom .r64                    #"
	@echo "###################################################"	
	
	cat $(PATH_EMPTY_ROM) > build/usr/share/carts/emptyset.r64
	cat $(PATH_EMPTY_ROM) >> build/usr/share/carts/emptyset.r64
	cat $(PATH_EMPTY_ROM) >> build/usr/share/carts/emptyset.r64
	cat $(PATH_EMPTY_ROM) >> build/usr/share/carts/emptyset.r64

twilightecardorixstandalonerom:
	@echo "###################################################"
	@echo "#    Build .rom standalone                     #"
	@echo "###################################################"	

	cp $(PATH_EMPTY_ROM) roms/twilighte_card_v05/6502/empty.rom
	cp usr/share/forth/2021.2/forth.rom  roms/twilighte_card_v05/6502/
	cp src/monitor/monitor.rom roms/twilighte_card_v05/6502/

	cp src/monitor/monitor.rom build/usr/share/roms/
	cp usr/share/forth/2021.2/forth.rom build/usr/share/roms/
	cat $(PATH_EMPTY_ROM) > build/usr/share/roms/empty.rom

#twilightecard_64KB_blocks_29F040:
	#cat ../empty-rom32/emptyrom8.rom  > roms/twilighte_card_v05/6502/empty.r64
	#cat ../empty-rom32/emptyrom9.rom >> roms/twilighte_card_v05/6502/empty.r64
	#cat ../empty-rom32/emptyrom10.rom >> roms/twilighte_card_v05/6502/empty.r64
	#cat ../empty-rom32/emptyrom11.rom >> roms/twilighte_card_v05/6502/empty.r64

twilightecard_firmware1:
	echo Generating for Twilighte card 8 banks root sd
	# 0
	cat empty-rom/emptyrom.rom > roms/twilighte_card_v05/6502/orixsd.rom
	# 1
	cat empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	# 2
	cat usr/share/forth/2021.2/forth.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	# 3
	cat monitor/monitor.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	# 4
	cat ../shell/shell.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	# 5
	cat basicsd.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	# 6
	cat ../kernel/kernel.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	# 7
	cat ca65.rom >> roms/twilighte_card_v05/6502/orixsd.rom	
	cat ../empty-rom32/emptyrom8.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom9.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom10.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom11.rom >> roms/twilighte_card_v05/6502/orixsd.rom	
	cat ../empty-rom32/emptyrom12.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom13.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom14.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom15.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom16.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom17.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom18.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom19.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom20.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom21.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom22.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom23.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom24.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom25.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom26.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom27.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom28.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom29.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom30.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom31.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat ../empty-rom32/emptyrom32.rom >> roms/twilighte_card_v05/6502/orixsd.rom

	cat ../empty-rom32/emptyrom10.rom > roms/twilighte_card_v05/6502/bankempty64.rom
	cat ../empty-rom32/emptyrom10.rom >> roms/twilighte_card_v05/6502/bankempty64.rom
	cat ../empty-rom32/emptyrom10.rom >> roms/twilighte_card_v05/6502/bankempty64.rom
	cat ../empty-rom32/emptyrom10.rom >> roms/twilighte_card_v05/6502/bankempty64.rom
	
twilightecardnoacia:
	echo Generating for Twilighte card no acia
	cat empty-rom/emptyrom.rom > orixnoacia.rom
	cat empty-rom/emptyrom.rom >> orixnoacia.rom
	cat usr/share/forth/2021.2/forth.rom >> orixnoacia.rom
	cat monitor/monitor.rom >> orixnoacia.rom
	cat ../shell/shell.rom >> orixnoacia.rom
	cat basic/bin/basic_noram.rom  >> orixnoacia.rom
	cat ../kernel/kernelnoaciatwil.rom >> orixnoacia.rom

test:
	cd build && tar -c * > ../carts.tar &&	cd ..
	gzip carts.tar
	mv carts.tar.gz carts.tgz
	php buildTestAndRelease/publish/publish2repo.php carts.tgz ${hash} 6502 tgz $(RELEASE)

