library ieee;
use ieee.std_logic_1164.all, ieee.math_real.all;

entity blinky is 
	generic
		( clk_freq_hz   : natural    := 48000000
		; blink_freq_hz : real       := 1.0
		; rst_polarity  : std_ulogic := '0'
		) ;

	port
		( clk48      : in std_ulogic
		; usr_btn    : in std_ulogic --rst 
		; rgb_led0_r :out std_ulogic
		; rgb_led0_g :out std_ulogic
		; rgb_led0_b :out std_ulogic
		) ;
end entity;

architecture blinky_arch of blinky is
	
	constant counter_max : natural := 
		natural(ceil(real(clk_freq_hz/2) / blink_freq_hz));
	subtype counter_t is natural range 0 to counter_max;
	signal counter : counter_t ;
	signal led_state : std_ulogic ;

begin
process(clk48)
begin
	if rising_edge(clk48) then
		if usr_btn = rst_polarity then
			led_state <= '1';
			counter <= 0;
		elsif counter = counter_max then
			led_state <= not led_state;
			counter <= 0;
		else
			counter <= counter + 1;
		end if;
	end if;
end process;
rgb_led0_r <= led_state;
rgb_led0_g <= led_state;
rgb_led0_b <= led_state;
end blinky_arch;
