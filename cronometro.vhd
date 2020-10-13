library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity cronometro is
	port(
		en, clk, arst	: in  std_logic;
		disp7	: out	std_logic_vector(6 downto 0);
		an		: out	std_logic_vector(3 downto 0)
	);
end cronometro;

architecture Behavioral of cronometro is

	component counter is
	generic(
		N		:	integer := 23;
		MAX	: 	integer := 12000000
	);
	port(
		en, clk, arst, srst	: in  std_logic;
		count	: out	std_logic_vector(N-1 downto 0);
		last 	: out std_logic
	);
	end component counter;
	
	component an_decoder is
	port(
		bin	: in  std_logic_vector(1 downto 0);
		o		: out std_logic_vector(3 downto 0)
	);
	end component an_decoder;
	
	component seg7_decoder is
	port(
		bin	: in  std_logic_vector(3 downto 0);
		o		: out std_logic_vector(6 downto 0)
	);
	end component seg7_decoder;
	
	component ffd is
	port(
			clk, rst, en, d	: in std_logic;
			q	: out std_logic
	);
	end component ffd;
	
	component mux4xN is
	generic (
		N : integer := 4
	);
	port(
		in00 : in  std_logic_vector (N-1 downto 0);
		in01 : in  std_logic_vector (N-1 downto 0);
		in10 : in  std_logic_vector (N-1 downto 0);
		in11 : in  std_logic_vector (N-1 downto 0);
		sel  : in  std_logic_vector (1 downto 0);
		o    : out std_logic_vector (N-1 downto 0)
	);
	end component mux4xN;
	
	component debounce is
	generic(
		counter_size  :  INTEGER := 19); --counter size (19 bits gives 10.5ms with 50MHz clock)
	port(
		clk     : IN  STD_LOGIC;  --input clock
		button  : IN  STD_LOGIC;  --input signal to be debounced
		result  : OUT STD_LOGIC); --debounced signal
	end component debounce;
	
	signal disp7_s	: std_logic_vector(6 downto 0);
	signal an_s		: std_logic_vector(3 downto 0);
	signal count0_s: std_logic_vector(3 downto 0);
	signal count1_s: std_logic_vector(3 downto 0);
	signal count2_s: std_logic_vector(3 downto 0);
	signal count3_s: std_logic_vector(3 downto 0);
	signal count5_s: std_logic_vector(22 downto 0);
	signal muxo_s	: std_logic_vector(3 downto 0);
	signal muxsel_s: std_logic_vector(1 downto 0);
	signal last0_s	: std_logic;
	signal last1_s	: std_logic;
	signal last2_s	: std_logic;
	signal last4_s	: std_logic;
	signal and1_s	: std_logic;
	signal and2_s	: std_logic;
	signal and3_s	: std_logic;
	signal ffdq_s	: std_logic;
	signal ffdd_s	: std_logic;
	signal en_s		: std_logic;
	signal result	: std_logic;
	signal last_result	: std_logic;
	
begin

	D0 : debounce
	generic map(
		counter_size => 20
	)
	port map(
		clk		=> clk,
		button	=> en,
		result	=> result
	);

	FFD0 : ffd
	port map(
		clk 	=> clk,
		rst 	=> arst,
		en 	=> en_s,
		d		=>	ffdd_s,
		q		=> ffdq_s
	);
	
	MUX0 : mux4xN
	generic map(
		N => 4
	)
	port map(
		in00	=> count0_s,
		in01	=> count1_s,
		in10	=> count2_s,
		in11	=> count3_s,
		sel 	=> muxsel_s,
		o  	=> muxo_s
	);
	
	AN0 : an_decoder
	port map(
		bin 	=> muxsel_s,
		o 		=> an_s
	);
	
	SEG0 : seg7_decoder
	port map(
		bin	=> muxo_s,
		o 		=> disp7_s
	);
	
	CR0 : counter
	generic map(
		N => 4,
		MAX => 9
	)
	port map(
		en		=> last4_s, 
		clk	=> clk, 
		arst	=> arst, 
		srst	=> '0',
		count	=> count0_s,
		last 	=> last0_s
	);
	
	CR1 : counter
	generic map(
		N => 4,
		MAX => 9
	)
	port map(
		en		=> and1_s, 
		clk	=> clk, 
		arst	=> arst, 
		srst	=> '0',
		count	=> count1_s,
		last 	=> last1_s
	);
	
	CR2 : counter
	generic map(
		N => 4,
		MAX => 5
	)
	port map(
		en		=> and2_s, 
		clk	=> clk, 
		arst	=> arst, 
		srst	=> '0',
		count	=> count2_s,
		last 	=>	last2_s
	);
	
	CR3 : counter
	generic map(
		N => 4,
		MAX => 9
	)
	port map(
		en		=> and3_s, 
		clk	=> clk, 
		arst	=> arst, 
		srst	=> '0',
		count	=> count3_s,
		last 	=> open
	);
	
	CR_stepper : counter
	generic map(
		N => 23,
		MAX => 5000000
	)
	port map(
		en		=> ffdq_s, 
		clk	=> clk, 
		arst	=> arst, 
		srst	=> '0',
		count	=> open,
		last 	=> last4_s
	);
	
	CR5_display : counter
	generic map(
		N => 23,
		MAX => 8388607 
	)
	port map(
		en		=> '1', 
		clk	=> clk, 
		arst	=> '0', 
		srst	=> '0',
		count	=> count5_s,
		last 	=> open
	);
	
	and1_s	<= last4_s and last0_s;
	and2_s	<= last4_s and last0_s and last1_s;
	and3_s	<= last4_s and last0_s and last1_s and last2_s;	
	
	ffdd_s	<= not ffdq_s;
	
	muxsel_s	<= count5_s(18 downto 17);
	
	disp7	<= disp7_s;
	an		<= an_s;
	
	process (clk, arst)
	begin
		if arst = '1' then
		elsif rising_edge(clk) then
			last_result <= result;
		end if;
	end process;
	
	en_s <=	'1' when last_result = '0' and result = '1' else
				'0';

end Behavioral;