library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ffd is
	port(
			clk, rst, en, d	: in std_logic;
			q	: out std_logic
	);
end ffd;

architecture Behavioral of ffd is
begin
	
	flipflop: process(clk, rst)
	begin
		if(rst = '1') then
			q <= '0';
		elsif(rising_edge(clk)) then
			if(en = '1') then
				q <= d;
			end if;
		end if;
	end process;

end Behavioral;