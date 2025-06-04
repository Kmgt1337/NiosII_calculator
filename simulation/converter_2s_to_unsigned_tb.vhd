library ieee;
use ieee.std_logic_1164.all;

entity converter_2s_to_unsigned_tb is
end entity;

architecture Simulation of converter_2s_to_unsigned_tb is 

component converter_2s_to_unsigned is
	port (
		clk             : in  std_logic;
		reset           : in  std_logic;
		number          : in  std_logic_vector(10 downto 0); 
		neg_ena		: out std_logic;
		unsigned_number : out std_logic_vector(10 downto 0) 
	);
end component;

signal clk, reset, neg_ena :  std_logic := '0';
signal number, unsigned_number : std_logic_vector(10 downto 0) := (others => '0');

begin
	uut : converter_2s_to_unsigned port map(clk, reset, number, neg_ena, unsigned_number);
	clk <= not clk after 5 ns;
	process
	begin
		reset <= '0';
		wait for 10 ns;

		reset <= '1';
		number <= "11111111111";
		wait for 100 ns;

		number <= "01111111111";
		wait for 100 ns;
	end process;
end architecture;
