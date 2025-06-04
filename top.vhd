library ieee;
use ieee.std_logic_1164.all;

entity top is
	port
	(
		clk 	: in std_logic;
		reset : in std_logic;
		switches : in std_logic_vector(9 downto 0);
		buttons  : in std_logic_vector(1 downto 0);
		leds		: out std_logic_vector(9 downto 0);
		hex0		: out std_logic_vector(7 downto 0);
		hex1		: out std_logic_vector(7 downto 0);
		hex2		: out std_logic_vector(7 downto 0);
		hex3		: out std_logic_vector(7 downto 0);
		hex4		: out std_logic_vector(7 downto 0);
		hex5		: out std_logic_vector(7 downto 0)
	);
end entity;

architecture arch of top is

	signal number : std_logic_vector(10 downto 0);
	signal neg_in_ena : std_logic;
	signal neg_ena : std_logic;
	signal number_abs : std_logic_vector(10 downto 0);
	
	component nios2 is
		port (
			clk_clk       : in  std_logic                     := 'X';             -- clk
			input_export  : in  std_logic_vector(10 downto 0) := (others => 'X'); -- export
			output_export : out std_logic_vector(10 downto 0);                    -- export
			reset_reset_n : in  std_logic                     := 'X'              -- reset_n
		);
	end component nios2;
	
	component seven_segments_contrl is
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
end component;

	component converter_2s_to_unsigned is
		port (
			clk             : in  std_logic;
			reset           : in  std_logic;
			number          : in  std_logic_vector(10 downto 0); 
			neg_ena			 : out std_logic;
			unsigned_number : out std_logic_vector(10 downto 0) 
		);
	end component;
	
begin

	processor0 : nios2 
	port map
	(
		clk_clk => clk,
		input_export => buttons(0) & switches,
		output_export => number,
		reset_reset_n => reset
	);
	
	leds <= number_abs(9 downto 0);
	
	
	disp_contrl : seven_segments_contrl
	port map
	(
		clk => clk,
		neg_ena_in => neg_in_ena,
		neg_ena => neg_ena,
		number => number_abs,
		hex0 => hex0,
		hex1 => hex1,
		hex2 => hex2,
		hex3 => hex3,
		hex4 => hex4,
		hex5 => hex5
	);
	
	converter : converter_2s_to_unsigned
	port map
	(
		clk => clk,
		reset => reset,
		number => number,
		neg_ena => neg_ena,
		unsigned_number => number_abs
	);
		
	process(switches)
	begin
		if switches(9) = '1' then
			neg_in_ena <= '1';
		else
			neg_in_ena <= '0';
		end if;
	end process;

end architecture;