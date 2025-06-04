library ieee;
use ieee.std_logic_1164.all;

entity seven_seg_tb is
end entity;

architecture Simulation of seven_seg_tb is

component seven_seg is
	port
	(
		neg_ena			: std_logic;
		neg_in_ena		: std_logic;
		inputBCD  		: in std_logic_vector(3 downto 0); 
		outputHEX 		: out std_logic_vector(7 downto 0)
	);
end component;

signal neg_ena, neg_in_ena : std_logic;
signal inputBCD : std_logic_vector(3 downto 0);
signal outputHEX : std_logic_vector(7 downto 0);

begin
	uut : seven_seg port map(neg_ena, neg_in_ena, inputBCD, outputHEX);

	process
	begin
		neg_ena <= '0';
		neg_in_ena <= '0';
		inputBCD <= "0011";
		wait for 10 ns;

		neg_ena <= '1';
		wait for 10 ns;

		neg_ena <= '0';
		neg_in_ena <= '1';
		wait for 10 ns;

		neg_ena <= '1';
		wait;
	end process;

end Simulation;
