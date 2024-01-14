ecppack --compress --freq 38.8 --input blinky.txt --bit blinky.bit &&
dfu-suffix -v 1209 -p 5af0 -a blinky.bit
