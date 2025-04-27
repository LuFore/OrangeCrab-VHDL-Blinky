define helpstr
build              -- builds the project
synth              -- synthesizes the build project
pnr                -- place and routes the synthesized project
generate_bitstream -- generates a bitstream from the pnr'd project
load_bistream      -- loads the generated bitstream onto the device
all                -- does all of the above
clean              -- removes all output files
help               -- displays this message 
endef
export helpstr

all : build synth pnr generate_bitstream load_bitstream 

build : 
	ghdl -a blinky.vhd 
	ghdl -e blinky

synth : 
	yosys -m ghdl -p 'ghdl blinky; synth_ecp5 -json synth_blinky.json'

pnr : 
	nextpnr-ecp5 --json synth_blinky.json --85k --package CSFBGA285 --lpf orangecrab_constraints.lpf --textcfg blinky.txt

generate_bitstream :
	ecppack --compress --freq 38.8 --input blinky.txt --bit blinky.bit
	dfu-suffix -v 1209 -p 5af0 -a blinky.bit

load_bitstream : 
	dfu-util -a 0 -D blinky.bit 

clean : 
	rm blinky
	rm *.bit
	rm *.o
	rm *.txt
	rm *.json
	rm *.cf

help : 
	@echo "$$helpstr"

