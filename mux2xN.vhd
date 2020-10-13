library ieee;
use ieee.std_logic_1164.all;

entity mux2xN is
  generic (
    N : integer := 23
  );
  port (
    a, b	: in  std_logic_vector(N-1 downto 0);
    s : in  std_logic;
    o : out std_logic_vector(N-1 downto 0)
  );
end mux2xN;

architecture behavioral of mux2xN is

begin

  o <= a when s = '0' else
       b;

end Behavioral;