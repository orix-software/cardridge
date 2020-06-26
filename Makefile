AS=xa
CC=cl65
CFLAGS=-ttelestrat
LDFILES=
ASCA65=ca65
ORIX_ROM=roms
BRANCH=master
VERSION=2020.3


all : init buildme twilightecard  twilightecardorixcfgkernel twilightecardorixcfgforthetc telestratcardridge  
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
else
RELEASE:=$(shell cat VERSION)
endif
endif


LIST="empty-rom shell basic orix monitor forth"
clean:
	rm -rf src/*
init:
	@mkdir -p src/
	@export MAKE=make
	@echo Update kernel
	@if [ -d "src/kernel" ]; then cd src/kernel && git pull && cd ../../ ; else cd src && git clone https://github.com/orix-software/kernel.git --recursive -b ${BRANCH}; fi 
	@echo Update shell
	@if [ -d "src/shell" ]; then  cd src/shell && rm -f src/build.inc && git pull && git submodule init && git submodule update --recursive --remote && cd ../../; else cd src && git clone https://github.com/orix-software/shell.git --recursive -b ${BRANCH}; fi 
	@echo Update empty-rom
	@if [ -d "src/empty-rom" ]; then  cd src/empty-rom  && git pull && git submodule  init && git submodule update --recursive --remote && cd ../../; else cd  src/ && git clone $(empty_rom_git) -b ${BRANCH} && cd ..;fi 
	@echo Update monitor
	@if [ -d "src/monitor" ]; then  cd src/monitor  && git pull && git submodule  init && git submodule update --recursive --remote && cd ../../; else cd  src/ && git clone $(monitor_git) -b ${BRANCH}  && cd ..;fi 	
	@echo Update forth
	@if [ -d "src/forth" ]; then  cd src/forth  && git pull && git submodule  init && git submodule update --recursive --remote && cd ../../; else cd  src/ && git clone $(forth_git) -b ${BRANCH}  && cd ..;fi 		
	@echo Update basic
	@if [ -d "src/basic" ]; then  cd src/basic  && git pull && git submodule  init && git submodule update --recursive --remote && cd ../../; else cd  src/ && git clone $(basic_git)  && cd ..;fi 			
	@echo Update md2hlp
	@if [ -d "src/md2hlp" ]; then  cd src/md2hlp  && git pull && git submodule  init && git submodule update --recursive --remote && cd ../../; else cd  src/ && git clone $(md2hlp_git)  && cd ..;fi 				
	@mkdir src/forth/md2hlp/src -p
	@cp src/md2hlp/src/* src/forth/md2hlp/src
	@cp src/md2hlp/src/md2hlp.py3 src/forth/md2hlp/src/md2hlp.py
	@cd src/forth/md2hlp/src/ && dos2unix *	
	mkdir -p roms/oricutron/6502/
	mkdir -p roms/oricutron/65c02/
	mkdir -p roms/telestrat/6502/
	mkdir -p roms/telestrat/65c02/
	mkdir -p roms/twilighte_card_v05/6502/		
	mkdir -p roms/twilighte_card_v05/65c02/	
	mkdir -p build/usr/share/carts/
  
buildme:
	#git clone	https://github.com/oric-software/buildTestAndRelease.git
	#git clone   https://github.com/assinie/md2hlp.git


	@echo "##########################"
	@echo "#    Building Shell      #"
	@echo "##########################"
	@cd src/shell && make
	@echo "##########################"
	@echo "#    Building Empty rom  #"
	@echo "##########################"
	@cd src/empty-rom/ && make
	@echo "##########################"
	@echo "#    Building Kernel     #"
	@echo "##########################"
	@cd src/kernel/ && make
	@echo "##########################"
	@echo "#    Building Monitor    #"
	@echo "##########################"	
	@cd src/monitor && make
	@echo "##########################"
	@echo "#    Building Basic      #"
	@echo "##########################"	
	#@cd src/basic && cd src/ && dos2unix * && cd .. && ./configure && make USB_MODE=sdcard COPYRIGHT_MSG='"BASIC 1.1 SD/JOY v2020.1"' JOYSTICK=YES
	wget http://repo.orix.oric.org/dists/official/tgz/6502/basic.tgz && tar xvfz basic.tgz && ls&& cp usr/share/basic/*/*.rom .
	
	@echo "##########################"
	@echo "#    Building Forth      #"
	@echo "##########################"
	@cd src/forth/md2hlp/src/ && dos2unix *			
	@cd src/forth && make configure && make	

	#@cd forth && make configure && make && make
telestratcardridge:	
	@echo "###################################"
	@echo "#    Build Telestrat cardridge    #"
	@echo "###################################"	

	echo Generating for telestrat First cardridge
	cat src/empty-rom/emptyrom.rom > roms/telestrat/6502/cardridge_first_slot_3_banks.rom
	cat src/shell/shellsd.rom >> roms/telestrat/6502/cardridge_first_slot_3_banks.rom
	cat basicsd.rom   >> roms/telestrat/6502/cardridge_first_slot_3_banks.rom
	cat src/kernel/kernelsd.rom >> roms/telestrat/6502/cardridge_first_slot_3_banks.rom
	echo Generating for telestrat Second cardridge
	cat src/forth/build/cart/TeleForth.rom > roms/telestrat/6502/cardridge_second_slot_4_banks.rom
	cat src/monitor/monitor.rom >> roms/telestrat/6502/cardridge_second_slot_4_banks.rom
	cat src/empty-rom/emptyrom.rom >> roms/telestrat/6502/cardridge_second_slot_4_banks.rom
	cat src/empty-rom/emptyrom.rom >> roms/telestrat/6502/cardridge_second_slot_4_banks.rom
	
	
	


twilightecard:
	@echo "###################################"
	@echo "#    Build Twilighte board ROM    #"
	@echo "###################################"	

#	echo Generating for Twilighte card 7 banks root usbkey
#	cat empty-rom/emptyrom.rom > roms/twilighte_card_v05/6502/orix.rom
#	cat empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orix.rom
#	cat forth/build/cart/TeleForth.rom >> roms/twilighte_card_v05/6502/orix.rom
#	cat monitor/monitor.rom >> roms/twilighte_card_v05/6502/orix.rom
#	cat shell/shell.rom >> roms/twilighte_card_v05/6502/orix.rom
#	cat basic/bin/basic_noram.rom  >> roms/twilighte_card_v05/6502/orix.rom
#	cat kernel/kernel.rom >> roms/twilighte_card_v05/6502/orix.rom
	echo Generating for Twilighte card 7 banks root sd
	#cp   src/empty-rom/emptyrom.rom /usr/share/emptyrom/2020.1/
	#cp   src/forth/build/cart/TeleForth.rom /usr/share/forth/2020.1/forth.rom
	#cp   src/shell/shellsd.rom /usr/share/shellsd/2020.2/
	#cp   src/shell/kernelsd.rom /usr/share/kernelsd/2020.2/
	#echo "Emptyrom 2020.1;/usr/share/emptyrom/2020.1/emptyrom.rom" > build/etc/orixcfg/roms.cnf
	#echo "Kernelsd 2020.2;/usr/share/kernel/2020.2/kernelsd.rom" >> build/etc/orixcfg/roms.cnf
	#echo "Shell 2020.2;/usr/share/shell/2020.2/shellsd.rom" >> build/etc/orixcfg/roms.cnf
	#echo "Monitor 2020.1;/usr/share/monitor/2020.1/monitor.rom" >> build/etc/orixcfg/roms.cnf
	#echo "Forth 2020.1;/usr/share/forth/2020.1/forth.rom" >> build/etc/orixcfg/roms.cnf
	#echo "Basicsdjoy 2020.1;/usr/share/basic11/2020.1/basicsd.rom" >> build/etc/orixcfg/roms.cnf

	cat src/empty-rom/emptyrom.rom > roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/forth/build/cart/TeleForth.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/monitor/monitor.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/shell/shellsd.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat basicsd.rom  >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/kernel/kernelsd.rom >> roms/twilighte_card_v05/6502/orixsd.rom	
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom	
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/orixsd.rom
twilightecardorixcfgkernel:
	@echo "###################################################"
	@echo "#    Build .r64 orixcfg (kernel, basic11 & shell )#"
	@echo "###################################################"	

	cat src/shell/shellsd.rom > roms/twilighte_card_v05/6502/kernelsd.r64
	cat basicsd.rom  >> roms/twilighte_card_v05/6502/kernelsd.r64
	cat src/kernel/kernelsd.rom >> roms/twilighte_card_v05/6502/kernelsd.r64
	cat src/empty-rom/emptyrom.rom >> roms/twilighte_card_v05/6502/kernelsd.r64
	mkdir build/usr/share/carts/$(VERSION)/ -p
	mkdir -p build/etc/orixcfg/
	echo "Kernelsd, basic11sd, shellsd;/usr/share/carts/$(VERSION)/kernelsd.r64" > build/etc/orixcfg/carts.cnf
	cp roms/twilighte_card_v05/6502/kernelsd.r64 build/usr/share/carts/$(VERSION)/

twilightecardorixcfgforthetc:
	@echo "###################################################"
	@echo "#    Build .r64 orixcfg forth                     #"
	@echo "###################################################"	

	cat src/empty-rom/emptyrom.rom > roms/twilighte_card_v05/6502/bank4321.r64
	cat src/monitor/monitor.rom >> roms/twilighte_card_v05/6502/bank4321.r64
	cat src/forth/build/cart/TeleForth.rom >> roms/twilighte_card_v05/6502/bank4321.r64
	cat src/monitor/monitor.rom >> roms/twilighte_card_v05/6502/bank4321.r64
	mkdir build/usr/share/carts/$(VERSION)/ -p
	mkdir -p build/etc/orixcfg/
	cp roms/twilighte_card_v05/6502/bank4321.r64 build/usr/share/carts/$(VERSION)/mfee.r64
	echo "Monitor 2020.1-Forth 2020.1;/usr/share/carts/2020.1/mfee.r64" >> build/etc/orixcfg/carts.cnf



twilightecardorixstandalonerom:
	@echo "###################################################"
	@echo "#    Build .rom standalone                     #"
	@echo "###################################################"	

	cp src/empty-rom/emptyrom.rom roms/twilighte_card_v05/6502/empty.rom
	cp src/forth/build/cart/TeleForth.rom  roms/twilighte_card_v05/6502/
	cp src/monitor/monitor.rom roms/twilighte_card_v05/6502/



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
	cat forth/build/cart/TeleForth.rom >> roms/twilighte_card_v05/6502/orixsd.rom
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
	cat forth/build/cart/TeleForth.rom >> orixnoacia.rom
	cat monitor/monitor.rom >> orixnoacia.rom
	cat ../shell/shell.rom >> orixnoacia.rom
	cat basic/bin/basic_noram.rom  >> orixnoacia.rom
	cat ../kernel/kernelnoaciatwil.rom >> orixnoacia.rom

test:
	cd build && tar -c * > ../carts.tar &&	cd ..
	gzip carts.tar
	mv carts.tar.gz carts.tgz
	php buildTestAndRelease/publish/publish2repo.php carts.tgz ${hash} 6502 tgz $(RELEASE)

