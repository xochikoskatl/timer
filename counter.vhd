library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity counter is
	generic(
		N		:	integer := 23;
		MAX	: 	integer := 12000000
	);
	port(
		en, clk, arst, srst	: in  std_logic;
		count	: out	std_logic_vector(N-1 downto 0);
		last 	: out std_logic
	);
end counter;

architecture Behavioral of counter is

	component adder is
	generic(
		N : integer := 23
	);
	port (
		a, b	: in std_logic_vector(N-1 downto 0);
		s : out std_logic_vector(N-1 downto 0)
	);
	end component adder;
	
	component comp is
	generic(
		N	:	integer := 23
	);
	port(
		a, b	: in std_logic_vector(N-1 downto 0);
		c : out std_logic
	);
	end component comp;

	component mux2xN is
	generic(
		N : integer := 23
	);
	port (
		a, b	: in std_logic_vector(N-1 downto 0);
		s : in  std_logic;
		o : out std_logic_vector(N-1 downto 0)
	);
	end component mux2xN;
	
	component reg is
	generic(
		N : integer := 23
	);
	port(
			clk, rst, ena	: in std_logic;
			d	: in std_logic_vector(N-1 downto 0);
			q	: out std_logic_vector(N-1 downto 0)
	);
	end component reg;
	
	signal count_s	: std_logic_vector(N-1 downto 0);
	signal adders_s: std_logic_vector(N-1 downto 0);
	signal compc_s	: std_logic;
	signal muxo_s	: std_logic_vector(N-1 downto 0);
	signal muxsel_s: std_logic;

begin
	
	S0 : adder
	generic map(
		N => N
	)
	port map(
		a => count_s,
		b => std_logic_vector(to_unsigned(1, N)),
		s => adders_s
	);
	
	C0 : comp
	generic map(
		N => N
	)
	port map(
		a => count_s,
		b => std_logic_vector(to_unsigned(MAX, N)),
		c => compc_s
	);
	
	M0 : mux2xN
	generic map(
		N => N
	)
	port map(
		a	=> adders_s,
		b	=> std_logic_vector(to_unsigned(0, N)),
		s	=> muxsel_s,
		o	=> muxo_s
	);
	
	R0 : reg
	generic map(
		N => N
	)
	port map(
		clk 	=> clk, 
		rst 	=> arst, 
		ena 	=> en,
		d 		=> muxo_s,
		q		=> count_s
	);
	
	count <= count_s;
	muxsel_s <= compc_s or srst;
	last <= compc_s;

end Behavioral;