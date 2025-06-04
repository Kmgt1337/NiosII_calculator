library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_segments_contrl is
	port
	(
		clk 			: in std_logic;
		neg_ena_in 		: in std_logic;
		neg_ena			: in std_logic;
		number			: in std_logic_vector(10 downto 0);
		
		hex0			: out std_logic_vector(7 downto 0);
		hex1			: out std_logic_vector(7 downto 0);
		hex2			: out std_logic_vector(7 downto 0);
		hex3			: out std_logic_vector(7 downto 0);
		hex4			: out std_logic_vector(7 downto 0);
		hex5			: out std_logic_vector(7 downto 0)
	);
end entity;

architecture behavior of seven_segments_contrl is

component seven_seg is
	port
	(
		inputBCD  		: in std_logic_vector(3 downto 0); 
		outputHEX 		: out std_logic_vector(7 downto 0)
	);
end component;

component seven_seg_neg is
	port
	(
		neg_ena : in std_logic;
		hex	  : out std_logic_vector(7 downto 0)
	);
end component;

component seven_seg_neg_in is
	port
	(
		neg_ena_in  : in std_logic;
		hex	  		: out std_logic_vector(7 downto 0)
	);
end component;


signal bcd0, bcd1, bcd2, bcd3, bcd4, bcd5 : unsigned(10 downto 0);
signal num_temp : unsigned(10 downto 0);

begin
	process(clk)
	begin
		num_temp <= unsigned(number);
		bcd0 <= num_temp mod 10;
		bcd1 <= (num_temp / 10) mod 10;
		bcd2 <= (num_temp / 100) mod 10;
		bcd3 <= (num_temp / 1000) mod 1000;
	end process;
			
	segment0 : seven_seg 
	port map
	(
		inputBCD => std_logic_vector(bcd0(3 downto 0)),
		outputHEX => hex0
	);

	segment1 : seven_seg 
	port map
	(
		inputBCD => std_logic_vector(bcd1(3 downto 0)),
		outputHEX => hex1
	);

	segment2 : seven_seg 
	port map
	(
		inputBCD => std_logic_vector(bcd2(3 downto 0)),
		outputHEX => hex2
	);

	segment3 : seven_seg 
	port map
	(
		inputBCD => std_logic_vector(bcd3(3 downto 0)),
		outputHEX => hex3
	);

	segment4 : seven_seg_neg 
	port map
	(
		neg_ena => neg_ena,
		hex => hex4
	);

	segment5 : seven_seg_neg_in
	port map
	(
		neg_ena_in => neg_ena_in,
		hex		  => hex5
	);
	
end architecture;