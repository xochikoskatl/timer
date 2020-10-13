library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
  generic (
    N : integer := 23
  );
  port (
    a, b	: in  std_logic_vector(N-1 downto 0);
    s : out std_logic_vector(N-1 downto 0)
  );
end adder;

architecture behavioral of adder is

begin

  s <= std_logic_vector(unsigned(a) + unsigned(b));

end Behavioral;