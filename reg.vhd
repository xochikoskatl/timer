library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg is
	generic (
		N : integer := 23
	);
	port(
			clk, rst, ena	: in std_logic;
			d	: in std_logic_vector(N-1 downto 0);
			q	: out std_logic_vector(N-1 downto 0)
	);
end reg;

architecture Behavioral of reg is
begin
	
	flipflop: process(clk, rst)
	begin
		if(rst = '1') then
			q <= std_logic_vector(to_unsigned(0, N));
		elsif(rising_edge(clk)) then
			if(ena = '1') then
				q <= d;
			end if;
		end if;
	end process;

end Behavioral;