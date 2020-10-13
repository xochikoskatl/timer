library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity an_decoder is
	port(
		bin	: in  std_logic_vector(1 downto 0);
		o		: out std_logic_vector(3 downto 0)
	);
end an_decoder;

architecture Behavioral of an_decoder is

begin
	
	o <= 	"1110" when bin = "00" else 
			"1101" when bin = "01" else 
			"1011" when bin = "10" else 
			"0111"; 

end Behavioral;