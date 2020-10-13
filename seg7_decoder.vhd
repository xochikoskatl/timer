library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity seg7_decoder is
	port(
		bin	: in  std_logic_vector(3 downto 0);
		o		: out std_logic_vector(6 downto 0)
	);
end seg7_decoder;

architecture Behavioral of seg7_decoder is

begin
	
	o <= 	"1000000" when bin = "0000" else --0
			"1111001" when bin = "0001" else --1
			"0100100" when bin = "0010" else --2
			"0110000" when bin = "0011" else --3
			"0011001" when bin = "0100" else --4
			"0010010" when bin = "0101" else --5
			"0000010" when bin = "0110" else --6
			"1111000" when bin = "0111" else --7
			"0000000" when bin = "1000" else --8
			"0011000"; --9

end Behavioral;