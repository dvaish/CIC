test:
	cd ~/Documents/Berkeley/Muller/CIC/
	iverilog -o CIC_tb *.v
	vvp CIC_tb