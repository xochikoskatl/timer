library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comp is
	generic(
		N	:	integer := 23
	);
	port(
		a, b	: in  std_logic_vector(N-1 downto 0);
		c : out std_logic
	);
end comp;

architecture Behavioral of comp is
begin
	
	process(a, b)
	begin
		if(a = b) then
			c <= '1';
		else
			c <= '0';
		end if;
	end process;

end Behavioral;