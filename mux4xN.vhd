library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4xN is
  generic (
    N : integer := 4
  );
  port (
    in00 : in  std_logic_vector (N-1 downto 0);
    in01 : in  std_logic_vector (N-1 downto 0);
    in10 : in  std_logic_vector (N-1 downto 0);
    in11 : in  std_logic_vector (N-1 downto 0);
    sel  : in  std_logic_vector (1 downto 0);
    o    : out std_logic_vector (N-1 downto 0)
  );
end mux4xN;

architecture Behavioral of mux4xN is

begin

  o <= in00 when sel = "00" else
       in01 when sel = "01" else
       in10 when sel = "10" else
       in11;

end Behavioral;